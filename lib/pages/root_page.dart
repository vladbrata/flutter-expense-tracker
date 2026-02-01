import 'package:expense_tracker/pages/add_transactio_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/stat_page.dart';
import 'package:expense_tracker/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/style/app_styles.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  // Aici pui paginile tale
  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      StatPage(),
      AddTransactionPage(),
      const Center(child: Text("Wallet Page")),
      const Center(child: Text("Profile Page")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      // Folosim IndexedStack pentru a păstra starea paginilor
      body: IndexedStack(index: _currentIndex, children: _pages),

      // Mutăm FAB-ul aici pentru a fi vizibil pe toate paginile
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
        },
        backgroundColor: AppColors.globalAccentColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: NavBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
