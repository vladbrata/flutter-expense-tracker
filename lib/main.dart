import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/pages/loading_page.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/root_page.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // Înfășurăm toată aplicația într-un StreamProvider
    // În main.dart, în interiorul MultiProvider sau sub un alt Provider
    StreamProvider<MyUser?>(
      create: (context) => FirebaseAuth.instance.authStateChanges().asyncMap((
        user,
      ) async {
        if (user == null) return null;
        return DBService().getUserStream(user.uid).first; // Ia prima valoare
      }),
      initialData: null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          }
          if (authSnapshot.hasData && authSnapshot.data != null) {
            // User is logged in
            return StreamProvider<MyUser?>.value(
              value: DBService().getUserStream(authSnapshot.data!.uid),
              initialData: null,
              child: const AuthWrapper(),
            );
          }
          // User is not logged in
          return const LoginPage();
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // While waiting for user data from DB
    if (user == null) {
      return const LoadingPage();
    }

    // User data is available, show RootPage
    return const RootPage();
  }
}
