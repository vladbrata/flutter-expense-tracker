import 'package:flutter/material.dart';

class AppColors {
  // Culorile tale principale
  static const Color globalBackgroundColor = Color(0xFF050505);
  static const Color surface = Color(0xFF1E2228); // Culoarea pentru containere
  static const Color globalAccentColor = Color(0xFF00C853);
  static const Color globalTextMainColor = Colors.white;
  static const Color globalTextSecondaryColor = Colors.black;
}

class AppSpacing {
  // Margini și padding-uri standard
  static const double p20 = 20.0;
  static const double p15 = 15.0;
  static const double borderRadius = 15.0;
}

class AppTextStyles {
  // Stiluri de text predefinite
  static const TextStyle title = TextStyle(
    color: AppColors.globalTextMainColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: AppColors.globalTextSecondaryColor,
    fontSize: 15,
  );
}
