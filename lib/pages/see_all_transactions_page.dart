import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllTransactionsPage extends StatefulWidget {
  const SeeAllTransactionsPage({Key? key}) : super(key: key);

  @override
  State<SeeAllTransactionsPage> createState() => _SeeAllTransactionsPageState();
}

class _SeeAllTransactionsPageState extends State<SeeAllTransactionsPage> {
  // Păstrăm referința viitorului pentru a nu re-executa fetch-ul la orice mică schimbare de UI
  Future<void>? _fetchFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pornim descărcarea datelor doar dacă nu am pornit-o deja
    final user = Provider.of<MyUser?>(context);
    if (user != null && _fetchFuture == null) {
      _fetchFuture = DBService().fetchUserData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalAccentColor,
        title: const Text(
          'Your Transactions',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: SafeArea(
        // FutureBuilder ascultă procesul de fetch și știe când să schimbe ecranul
        child: FutureBuilder(
          future: _fetchFuture,
          builder: (context, snapshot) {
            // 1. Cât timp se încarcă datele din DB
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.globalAccentColor,
                ),
              );
            }

            // 2. Dacă a apărut o eroare la fetch
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Eroare: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            // 3. Când datele sunt gata, afișăm lista
            final transactions = user?.allTransactions ?? [];

            if (transactions.isEmpty) {
              return const Center(
                child: Text(
                  "No transactions found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Important în SingleChildScrollView
                    // Sortează-le aici dacă nu ai făcut-o deja în Getter-ul din MyUser
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return RecentTransactionWidget(
                        transaction: transactions[index],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
