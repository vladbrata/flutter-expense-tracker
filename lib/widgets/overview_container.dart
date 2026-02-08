import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewContainer extends StatefulWidget {
  OverviewContainer({Key? key}) : super(key: key);

  @override
  _OverviewContainerState createState() => _OverviewContainerState();
}

class _OverviewContainerState extends State<OverviewContainer> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 250,
            width: double.infinity,
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
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.globalTextMainColor,
                  ),
                ),
                Text(
                  user?.getBalance().toString() ?? '0.00',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.globalTextMainColor,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color.from(
                            alpha: 0.2,
                            red: 0.165,
                            green: 0.655,
                            blue: 0.18,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.trending_up,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Income",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              user?.getIncome().toString() ?? '0.00',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color.from(
                            alpha: 0.2,
                            red: 0.957,
                            green: 0.263,
                            blue: 0.212,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.trending_down,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Expenses",
                                    style: TextStyle(
                                      color: AppColors.globalTextMainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              user?.getExpense().toString() ?? '0.00',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
