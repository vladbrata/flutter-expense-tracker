import 'package:expense_tracker/style/app_styles.dart';
import 'package:flutter/material.dart';

class IncomeCategoryContainer extends StatefulWidget {
  const IncomeCategoryContainer({Key? key}) : super(key: key);

  @override
  State<IncomeCategoryContainer> createState() =>
      _IncomeCategoryContainerState();
}

class _IncomeCategoryContainerState extends State<IncomeCategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
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
          Row(
            children: [
              Text(
                'This Week',
                style: TextStyle(
                  color: AppColors.globalTextMainColor,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Text(
                'Total',
                style: TextStyle(
                  color: AppColors.globalAccentColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
