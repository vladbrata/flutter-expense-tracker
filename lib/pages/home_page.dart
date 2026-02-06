import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/widgets/greetings_widget.dart';
import 'package:expense_tracker/widgets/overview_container.dart';
import 'package:expense_tracker/widgets/recent_transaction_widget.dart';
import 'package:expense_tracker/widgets/week_overview_container.dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    fetchUserCategories(user);

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

Future<void> fetchUserCategories(MyUser? user) async {
  if (user == null) return;

  DatabaseReference ref = FirebaseDatabase.instance.ref(
    "users/${user.uid}/category",
  );

  try {
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      print("✅ exista");
      List<MyCategory> loadedCategories = [];
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        loadedCategories.add(
          MyCategory(
            name: value['name'],
            type: value['type'],
            // Convertim string-ul înapoi în IconData și Color
            icon: IconData(
              int.parse(value['icon']),
              fontFamily: 'MaterialIcons',
            ),
            color: Color(int.parse(value['color'])),
          ),
        );
      });

      user.categories = loadedCategories;
      print("✅ Am descărcat ${loadedCategories.length} categorii.");
    }
  } catch (e) {
    print("❌ Eroare la descărcare: $e");
  }
}
