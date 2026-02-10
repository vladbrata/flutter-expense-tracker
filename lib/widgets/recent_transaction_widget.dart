import 'package:expense_tracker/pages/expense_detail_page.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({Key? key, required this.transaction})
    : super(key: key);
  final dynamic transaction;

  @override
  Widget build(BuildContext context) {
    // Verificăm tipul tranzacției pentru a seta culorile
    final bool isIncome = transaction is Income;
    final Color mainColor = isIncome ? Colors.green : Colors.red;

    // Extragem data tranzacției
    final DateTime date = transaction.date;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TransactionDetailPage(transaction: transaction),
            ),
          );
        },
        child: Container(
          height: 65, // Am mărit puțin înălțimea pentru a face loc datei
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: mainColor,
            boxShadow: const [
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
                // Iconița de direcție
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ),

                // Coloana pentru Titlu și Dată
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${date.day}.${date.month}.${date.year}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Suma tranzacției
                Text(
                  "${isIncome ? '+' : '-'}${transaction.amount} RON",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
