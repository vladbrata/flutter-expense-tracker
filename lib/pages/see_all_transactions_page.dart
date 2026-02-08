import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllTransactionsPage extends StatelessWidget {
  const SeeAllTransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalAccentColor,
        title: const Text(
          textAlign: TextAlign.center,
          'Your Transactions',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: user?.allTransactions.length ?? 0,
                itemBuilder: (context, index) {
                  final transaction = user?.allTransactions[index];
                  return RecentTransactionWidget(transaction: transaction);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
