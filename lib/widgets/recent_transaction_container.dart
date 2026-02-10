import 'package:expense_tracker/pages/see_all_transactions_page.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionContainer extends StatelessWidget {
  const RecentTransactionContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Container(
      width: double.infinity,
      // margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Exemplu valoare
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeeAllTransactionsPage(),
                    ),
                  );
                },
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: AppColors.globalTextMainColor,
                    fontSize: 20,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeeAllTransactionsPage(),
                    ),
                  );
                },
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: AppColors.globalAccentColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // Luăm tranzacțiile, le inversăm și le transformăm în listă, apoi luăm primele 3
            itemCount: (user?.allTransactions.length ?? 0) > 3
                ? 3
                : (user?.allTransactions.length ?? 0),
            itemBuilder: (context, index) {
              // Inversăm lista aici pentru a avea ultima tranzacție la index 0
              final transaction = user?.allTransactions[index];

              return RecentTransactionWidget(transaction: transaction);
            },
          ),
        ],
      ),
    );
  }
}
