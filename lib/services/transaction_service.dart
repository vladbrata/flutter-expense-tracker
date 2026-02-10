import 'package:expense_tracker/services/category_class.dart';
import 'package:flutter/foundation.dart';
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
  final String comment;
  final MyCategory category;

  Expense({
    required this.date,
    required this.id,
    required this.title,
    required this.amount,
    // required this.date,
    required this.category,
    // required this.type,
    required this.userId,
    required this.comment,
  });
}

class Income {
  final DateTime date;
  final String id;
  final String title;
  final double amount;
  // final DateTime date;
  // final Category category;
  // final String type;
  final String userId;
  final String comment;
  final MyCategory category;

  Income({
    required this.date,
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.userId,
    required this.comment,
  });
}
