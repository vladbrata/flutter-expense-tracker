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
  MyUser? _currentUser;

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

  Future<void> _fetchUserData(MyUser user) async {
    await DBService().fetchUserData(user);
    await DBService().fetchCategories(user);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<MyUser?>(context);

    // Check if user object has changed (e.g. profile update or initial load)
    // We only fetch if the user instance is different to ensure we populate the new instance
    if (user != null && user != _currentUser) {
      _currentUser = user;
      _dataFetchFuture = _fetchUserData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Should not happen due to AuthWrapper, but good for safety
    if (_dataFetchFuture == null) {
      return const LoadingPage();
    }

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

              if (result == true) {
                // Re-fetch data if a new transaction was added
                setState(() {
                  if (_currentUser != null) {
                    _dataFetchFuture = _fetchUserData(_currentUser!);
                  }
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
