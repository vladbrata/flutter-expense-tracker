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
        // Pas 1: Ascultăm cine s-a logat
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData && authSnapshot.data != null) {
            // Pas 2: Dacă avem user logat, pornim citirea datelor lui din DB
            return StreamBuilder<MyUser?>(
              stream: DBService().getUserStream(authSnapshot.data!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage(); // Ecranul de loading menționat anterior
                }

                if (userSnapshot.hasData && userSnapshot.data != null) {
                  // Pas 3: Datele sunt gata! Avem obiectul MyUser.
                  // Putem să-l punem într-un Provider sau să-l dăm mai departe.
                  return const RootPage();
                }

                return const LoadingPage();
              },
            );
          }

          // Dacă nu e logat nimeni
          return const LoginPage();
        },
      ),
    );
  }
}
