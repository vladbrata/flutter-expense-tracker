import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DBService {
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://expense-tracker-8b7eb-default-rtdb.europe-west1.firebasedatabase.app/',
  ).ref();

  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _firebaseDatabase.child('users').child(uid).child('profile').set({
      'name': name,
      'email': email,
    });
  }

  Stream<MyUser?> getUserStream(String uid) {
    // 1. Facem referință către nodul 'profile' al utilizatorului specific

    // Structura în Firebase: users -> {uid} -> profile

    return _firebaseDatabase
        .child('users')
        .child(uid)
        .child('profile')
        .onValue
        .map((event) {
          // 2. Extragem datele brute din snapshot

          final data = event.snapshot.value;

          // 3. Verificăm dacă există date la acea locație

          if (data == null) {
            print("⚠️ [DBService] Nu s-au găsit date la users/$uid/profile");

            return null;
          }

          try {
            // 4. Convertim datele brute (Map) în obiectul MyUser

            // Realtime Database returnează Map<Object?, Object?>, deci forțăm conversia

            final Map<dynamic, dynamic> userMap = data as Map<dynamic, dynamic>;

            return MyUser.fromMap(userMap, uid);
          } catch (e) {
            print(
              "❌ [DBService] Eroare la maparea datelor pentru UID $uid: $e",
            );

            return null;
          }
        });
  }

  // --- SALVARE TRANZACȚIE CU OBIECT CATEGORY COMPLET ---
  Future<void> saveTransaction({
    required String transactionType,
    required String uid,
    required double amount,
    required String title,
    required String date,
    required String comment,
    required MyCategory category,
  }) async {
    try {
      final DatabaseReference transactionRef = _firebaseDatabase
          .child('users')
          .child(uid)
          .child(transactionType);

      await transactionRef.push().set({
        'amount': amount,
        'title': title,
        'date': date,
        'comment': comment,
        'category': {
          'id': category.id,
          'name': category.name,
          'icon': category.icon.codePoint.toString(),
          'type': category.type,
          'color': category.color.value.toString(),
        },
      });

      print("✅ $transactionType salvat cu succes cu obiect category!");
    } catch (e) {
      print("❌ Eroare la salvarea $transactionType: $e");
      rethrow;
    }
  }

  // --- FETCH USER DATA (EXPENSES & INCOME) ---
  Future<void> fetchUserData(MyUser user) async {
    DatabaseReference ref = _firebaseDatabase.child("users").child(user.uid);

    try {
      print("🚀 Încep fetch-ul pentru UID: ${user.uid}");
      DataSnapshot snapshot = await ref.get().timeout(
        const Duration(seconds: 10),
      );

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> userData =
            snapshot.value as Map<dynamic, dynamic>;

        // 1. PROCESARE EXPENSES
        if (userData['expenses'] != null) {
          user.expenses = _parseTransactions<Expense>(
            userData['expenses'],
            user.uid,
            (id, map) => Expense(
              id: id,
              userId: user.uid,
              amount: double.tryParse(map['amount'].toString()) ?? 0.0,
              title: map['title'] ?? "",
              date: DateTime.parse(map['date']),
              comment: map['comment'] ?? "",
              category: _parseCategory(map['category']),
            ),
          );
        }

        // 2. PROCESARE INCOME
        if (userData['income'] != null) {
          user.incomes = _parseTransactions<Income>(
            userData['income'],
            user.uid,
            (id, map) => Income(
              id: id,
              userId: user.uid,
              amount: double.tryParse(map['amount'].toString()) ?? 0.0,
              title: map['title'] ?? "",
              date: DateTime.parse(map['date']),
              comment: map['comment'] ?? "",
              category: _parseCategory(map['category']),
            ),
          );
        }
      }
      print(
        "🏁 FINAL: ${user.expenses.length} cheltuieli și ${user.incomes.length} venituri.",
      );
    } catch (e) {
      print("❌ EROARE FETCH: $e");
    }
  }

  // --- UTILS PENTRU PARSARE (LOGICĂ REUTILIZABILĂ) ---
  List<T> _parseTransactions<T>(
    dynamic data,
    String uid,
    T Function(String id, Map map) creator,
  ) {
    List<T> list = [];
    if (data is Map) {
      data.forEach((key, value) {
        if (value is Map) {
          try {
            list.add(creator(key.toString(), value));
          } catch (e) {
            print("⚠️ Eroare parsare tranzactie $key: $e");
          }
        }
      });
    }
    return list;
  }

  MyCategory _parseCategory(dynamic catData) {
    if (catData != null && catData is Map) {
      return MyCategory(
        id: catData['id'] ?? "",
        name: catData['name'] ?? "Unknown",
        type: catData['type'] ?? "Expense",
        icon: IconData(
          int.parse(catData['icon'] ?? "57585"), // Default icon if missing
          fontFamily: 'MaterialIcons',
        ),
        color: Color(int.parse(catData['color'] ?? "0xFFFFFFFF")),
      );
    }
    // Fallback în caz că datele sunt vechi (Legacy Support)
    return MyCategory(
      id: "legacy",
      name: "Old Category",
      type: "Expense",
      icon: Icons.help_outline,
      color: Colors.grey,
    );
  }

  // --- CATEGORII ---
  Future<void> addNewCategory(MyCategory newCat, MyUser user) async {
    await _firebaseDatabase
        .child("users")
        .child(user.uid)
        .child("category")
        .child(newCat.id) // Folosim ID-ul generat deja în UI
        .set({
          "name": newCat.name,
          "type": newCat.type,
          "icon": newCat.icon.codePoint.toString(),
          "color": newCat.color.value.toString(),
        });
  }

  Future<void> fetchCategories(MyUser user) async {
    try {
      DataSnapshot snapshot = await _firebaseDatabase
          .child("users")
          .child(user.uid)
          .child("category")
          .get();

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        user.categories = data.entries.map((e) {
          return MyCategory(
            id: e.key,
            name: e.value['name'],
            type: e.value['type'],
            icon: IconData(
              int.parse(e.value['icon']),
              fontFamily: 'MaterialIcons',
            ),
            color: Color(int.parse(e.value['color'])),
          );
        }).toList();
      }
    } catch (e) {
      print("❌ Eroare fetch categorii: $e");
    }
  }

  Future<void> deleteCategory(String uid, String categoryId) async {
    try {
      await _firebaseDatabase
          .child("users")
          .child(uid)
          .child("category")
          .child(categoryId)
          .remove();
    } catch (e) {
      print("❌ Eroare la ștergere: $e");
      rethrow;
    }
  }
}
