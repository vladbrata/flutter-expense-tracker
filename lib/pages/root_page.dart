import 'package:expense_tracker/pages/add_transactio_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/stat_page.dart';
import 'package:expense_tracker/pages/loading_page.dart';
import 'package:expense_tracker/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  Future<void>? _dataFetchFuture;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      StatPage(),
      AddTransactionPage(),
      const Center(
        child: Text("Wallet Page", style: TextStyle(color: Colors.white)),
      ),
      const Center(
        child: Text("Profile Page", style: TextStyle(color: Colors.white)),
      ),
    ];
  }

  // Creăm o funcție separată pentru pornirea procesului de fetch
  void _startFetching() {
    final user = Provider.of<MyUser?>(context, listen: false);
    if (user != null) {
      _dataFetchFuture = DBService().fetchUserData(user);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prima inițializare la deschiderea aplicației
    if (_dataFetchFuture == null) {
      _startFetching();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_dataFetchFuture == null) {
    //   return const LoadingPage();
    // }

    return FutureBuilder(
      future: _dataFetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.globalBackgroundColor,
            body: Center(
              child: Text(
                "Eroare la sincronizare: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.globalBackgroundColor,
          body: IndexedStack(index: _currentIndex, children: _pages),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionPage(),
                ),
              );

              // MODIFICARE AICI: Dacă s-a adăugat o tranzacție (result == true)
              if (result == true) {
                setState(() {
                  // Resetăm Future-ul pentru a forța FutureBuilder să re-afișeze LoadingPage
                  // și să cheme din nou funcția de fetch din DB
                  _startFetching();
                });
              }
            },
            backgroundColor: AppColors.globalAccentColor,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.black),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: NavBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
