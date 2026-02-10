import 'package:expense_tracker/services/transaction_service.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class TransactionDetailPage extends StatefulWidget {
  TransactionDetailPage({Key? key, required this.transaction})
    : super(key: key);

  final dynamic transaction;

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.globalTextMainColor),
        title: Text(
          widget.transaction is Income ? "Income Details" : "Expense Details",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
        backgroundColor: AppColors.globalAccentColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            color: AppColors.globalAccentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            widget.transaction.category.icon,
                            size: 40,
                            color: widget.transaction.category.color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.transaction.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.globalTextMainColor,
                          ),
                        ),
                        Text(
                          widget.transaction is Expense
                              ? "-${widget.transaction.amount}"
                              : "+${widget.transaction.amount}",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: widget.transaction is Expense
                                ? Colors.red
                                : AppColors.globalTextMainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color:
                          (widget.transaction is Expense
                                  ? Colors.red
                                  : Colors.green)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.transaction is Expense ? "Expense" : "Income",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.transaction is Expense
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                ),
                // Transaction Card
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.globalTextMainColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DETAILS",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Data
                      _buildDetailRow(
                        icon: Icons.calendar_month_outlined,
                        label: "Date",
                        value:
                            '${widget.transaction.date.day}/${widget.transaction.date.month}/${widget.transaction.date.year}', // Aici poți folosi formatarea datei tale
                      ),

                      // Category
                      _buildDetailRow(
                        icon: Icons.local_offer_outlined,
                        label: "Category",
                        value: widget
                            .transaction
                            .category
                            .name, // Folosește obiectul restructurat anterior
                      ),

                      // Note
                      _buildDetailRow(
                        icon: Icons.description_outlined,
                        label: "Note",
                        value: widget.transaction.comment,
                        isLast: true,
                      ),
                    ],
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

Widget _buildDetailRow({
  required IconData icon,
  required String label,
  required String value,
  bool isLast = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 25),
    child: Row(
      children: [
        // Cercul cu iconiță
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey, size: 22),
        ),
        const SizedBox(width: 15),

        // Textele
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
