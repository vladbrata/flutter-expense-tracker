import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Loading...",
          style: TextStyle(color: AppColors.globalTextMainColor, fontSize: 15),
        ),
      ],
    );
  }
}
