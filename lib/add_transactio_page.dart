import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool _isExpense = true;
  bool _isIncome = false;
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
                            child: TextField(decoration: InputDecoration()),
                          ),

                          Text(
                            'RON cheltuit',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
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
                            child: TextField(decoration: InputDecoration()),
                          ),

                          Text(
                            'RON primiti',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
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
