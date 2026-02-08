import 'package:flutter/material.dart';

class Expense {
  final DateTime date;
  final String id;
  final String title;
  final double amount;
  // final DateTime date;
  // final String category;
  // final String type;
  final String userId;

  Expense({
    required this.date,
    required this.id,
    required this.title,
    required this.amount,
    // required this.date,
    // required this.category,
    // required this.type,
    required this.userId,
  });
}

class Income {
  final DateTime date;
  final String id;
  final String title;
  final double amount;
  // final DateTime date;
  // final String category;
  // final String type;
  final String userId;

  Income({
    required this.date,
    required this.id,
    required this.title,
    required this.amount,
    // required this.date,
    // required this.category,
    // required this.type,
    required this.userId,
  });
}
