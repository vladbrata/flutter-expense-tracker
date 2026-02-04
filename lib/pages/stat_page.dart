import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class StatPage extends StatefulWidget {
  StatPage({Key? key}) : super(key: key);

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Your Stats',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [const SizedBox(height: 50)]),
        ),
      ),
    );
  }
}
