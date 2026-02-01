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
    await _firebaseDatabase.child('users').child(uid).set({
      'name': name,
      'email': email,
    });
  }

  // În DBService
  Stream<MyUser?> getUserStream(String uid) {
    return _firebaseDatabase.child('users').child(uid).onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return null;

      // Convertim datele în obiectul MyUser
      return MyUser.fromMap(data, uid);
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
}
