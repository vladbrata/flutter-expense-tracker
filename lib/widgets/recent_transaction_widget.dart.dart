import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);
  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    String? type = 'Income';
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: type == 'Income' ? Colors.green : Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Icon(
                  type == 'Income' ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: type == 'Income'
                      ? Colors.white
                      : AppColors.globalTextSecondaryColor,
                ),
              ),
              const Spacer(),
              Text(
                amount.toString(),
                style: TextStyle(
                  color: type == 'Income'
                      ? Colors.white
                      : AppColors.globalTextSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
