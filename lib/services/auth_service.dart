import 'package:expense_tracker/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    UserCredential credential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    try {
      await DBService().saveUser(
        uid: credential.user!.uid,
        name: name,
        email: email,
      );
      print("DEBUG: Salvarea în DB a fost finalizată fără erori.");
    } catch (e) {
      print("DEBUG EROARE DB: $e"); // Aici vei vedea dacă e "Permission Denied"
    }

    return credential;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
