import 'dart:ffi';

import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/widgets/category_container.dart';
import 'package:expense_tracker/widgets/greetings_widget.dart';
import 'package:expense_tracker/widgets/overview_container.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart';
import 'package:expense_tracker/widgets/week_overview_container.dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (user != null) {
      DBService().fetchCategories(user);
    }
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
              Text(
                "Categorie total: ${user?.categories.length}",
                style: TextStyle(color: AppColors.globalTextMainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
