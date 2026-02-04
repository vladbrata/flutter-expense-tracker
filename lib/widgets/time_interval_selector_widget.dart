import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class TimeIntervalSelectorWidget extends StatefulWidget {
  TimeIntervalSelectorWidget({Key? key}) : super(key: key);

  @override
  _TimeIntervalSelectorWidgetState createState() =>
      _TimeIntervalSelectorWidgetState();
}

class _TimeIntervalSelectorWidgetState
    extends State<TimeIntervalSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Daily',
            style: TextStyle(
              color: AppColors.globalTextMainColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            'Weekly',
            style: TextStyle(
              color: AppColors.globalTextMainColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            'Monthly',
            style: TextStyle(
              color: AppColors.globalTextMainColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          Text(
            'Yearly',
            style: TextStyle(
              color: AppColors.globalTextMainColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
