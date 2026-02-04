import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool _isExpense = true;
  bool _isIncome = false;
  String _selectedCategory = "Salariu";
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalAccentColor,
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: AppColors.globalAccentColor,
                ),
                height: 50,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpense = true;
                            _isIncome = false;
                          });
                        },
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            color: AppColors.globalTextMainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: _isExpense
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpense = false;
                            _isIncome = true;
                          });
                        },
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: AppColors.globalTextMainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: _isIncome
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isExpense)
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: amountController,
                              decoration: InputDecoration(),
                            ),
                          ),

                          Text(
                            'RON cheltuit',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // 1. Preluăm userul din Provider (cel setat în main.dart)
                          final user = Provider.of<MyUser?>(
                            context,
                            listen: false,
                          );

                          print(amountController.text);
                          // 2. Validăm datele (să nu fie goale)
                          if (user != null &&
                              amountController.text.isNotEmpty) {
                            print(
                              "User: ${user.name} vrea sa adauge o cheltuiala cu suma: ${amountController.text}",
                            );
                            try {
                              // Convertim textul în număr
                              double amount = double.parse(
                                amountController.text.trim(),
                              );

                              // 3. Apelăm funcția din DBService
                              await DBService().saveTransaction(
                                uid: user.uid,
                                amount: amount,
                                title: _selectedCategory,
                                transactionType: _isIncome
                                    ? 'income'
                                    : 'expenses',
                              );

                              // 4. Succes! Închidem pagina sau arătăm un mesaj
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Expense Saved Successfully"),
                                  ),
                                );
                                Navigator.pop(
                                  context,
                                ); // Ne întoarcem la pagina anterioară
                              }
                            } catch (e) {
                              // Gestionăm eroarea (ex: dacă utilizatorul scrie litere în loc de cifre)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: Invalid input!"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Save Expense"),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: amountController,
                              decoration: InputDecoration(),
                            ),
                          ),

                          Text(
                            'RON primiti',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          // 1. Preluăm userul din Provider (cel setat în main.dart)
                          final user = Provider.of<MyUser?>(
                            context,
                            listen: false,
                          );

                          print(amountController.text);
                          // 2. Validăm datele (să nu fie goale)
                          if (user != null &&
                              amountController.text.isNotEmpty) {
                            print(
                              "User: ${user.name} vrea sa adauge venit cu suma: ${amountController.text}",
                            );
                            try {
                              // Convertim textul în număr
                              double amount = double.parse(
                                amountController.text.trim(),
                              );

                              // 3. Apelăm funcția din DBService
                              await DBService().saveTransaction(
                                uid: user.uid,
                                amount: amount,
                                title: _selectedCategory,
                                transactionType: _isIncome
                                    ? 'income'
                                    : 'expenses',
                              );

                              // 4. Succes! Închidem pagina sau arătăm un mesaj
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Income saved successfully!"),
                                  ),
                                );
                                Navigator.pop(
                                  context,
                                ); // Ne întoarcem la pagina anterioară
                              }
                            } catch (e) {
                              // Gestionăm eroarea (ex: dacă utilizatorul scrie litere în loc de cifre)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: Invalid input!"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Save Income"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
