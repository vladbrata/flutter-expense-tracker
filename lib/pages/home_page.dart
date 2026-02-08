import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/widgets/greetings_widget.dart';
import 'package:expense_tracker/widgets/overview_container.dart';
import 'package:expense_tracker/widgets/recent_transaction_container.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart.dart';
import 'package:expense_tracker/widgets/week_overview_container.dart.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mutăm apelul de fetch aici pentru a nu bloca metoda build
    final user = Provider.of<MyUser?>(context);
    if (user != null && user.categories.isEmpty) {
      DBService().fetchCategories(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ascultăm schimbările din MyUser prin Provider
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          // BouncingScrollPhysics face lista să se simtă mai nativă pe iOS/Android
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const GreetingsWidget(),
              OverviewContainer(),
              const WeekOverviewContainer(),
              const RecentTransactionContainer(),

              const SizedBox(height: 30),

              // Datele se vor updata instant datorită Stream-ului din RootPage
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      "Total tranzacții cheltuieli",
                      "${user?.expenses.length ?? 0}",
                    ),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      "Total tranzacții venituri",
                      "${user?.incomes.length ?? 0}",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper pentru a menține codul curat
  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.globalTextMainColor.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.globalTextMainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
