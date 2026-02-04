import 'package:expense_tracker/widgets/greetings_widget.dart';
import 'package:expense_tracker/widgets/overview_container.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart';
import 'package:expense_tracker/widgets/week_overview_container.dart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/style/app_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GreetingsWidget(),
              OverviewContainer(),
              WeekOverviewContainer(),
              RecentTransactionWidget(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
