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
    // Verifică dacă instanța _firebaseDatabase are URL-ul de Belgia configurat!
    await _firebaseDatabase.child('users').child(uid).child('profile').set({
      'name': name,
      'email': email,
    });
  }

  // În DBService
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

  Future<DataSnapshot?> read(String path) async {
    final DatabaseReference ref = _firebaseDatabase.child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  Stream<MyUser?> getUserData(String uid) {
    return _firebaseDatabase.child('users').child(uid).onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return null;
      return MyUser.fromMap(data, uid);
    });
  }

  Future<void> saveTransaction({
    required String transactionType,
    required String uid,
    required double amount,
    required String title,
  }) async {
    try {
      // Referință către users -> UID -> incomes
      final DatabaseReference _incomeRef = _firebaseDatabase
          .child('users')
          .child(uid)
          .child(transactionType);

      // Generăm un ID unic pentru această tranzacție
      await _incomeRef.push().set({'amount': amount, 'title': title});

      print("✅ $transactionType salvat cu succes!");
    } catch (e) {
      print("❌ Eroare la salvarea $transactionType: $e");
      rethrow;
    }
  }
}
