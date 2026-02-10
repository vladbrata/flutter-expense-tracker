import 'package:expense_tracker/pages/transaction_detail_page.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class RecentTransactionWidget extends StatelessWidget {
  const RecentTransactionWidget({Key? key, required this.transaction})
    : super(key: key);
  final dynamic transaction; // Poate fi Expense sau Income

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction is Income;

    // Extragem obiectul categoriei direct din tranzacție
    final category = transaction.category;
    final DateTime date = transaction.date;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surface, // Fundal neutru pentru contrast
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                // Iconița Categoriei (folosind datele din obiectul category)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(
                      0.2,
                    ), // Culoarea categoriei
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon, // IconData din obiect
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),

                // Coloana pentru Titlu și Nume Categorie
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${date.day}.${date.month}.${date.year}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Suma tranzacției (Verde pentru venit, Alb pentru cheltuială)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${isIncome ? '+' : '-'}${transaction.amount} RON",
                      style: TextStyle(
                        color: isIncome
                            ? AppColors.globalAccentColor
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // Mic indicator de tip (săgeată)
                    Icon(
                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isIncome ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
