import 'dart:collection';
import 'dart:ffi';

import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final String email;
  final String name;
  final String uid;
  List<MyCategory> categories = [];
  List<Expense> expenses = []; // Lista globală cheltuieli
  List<Income> incomes = []; // Lista globală venituri
  List<dynamic> get allTransactions {
    // Combinăm listele
    List<dynamic> combined = [...expenses, ...incomes];

    // Sortăm descrescător (cele mai noi primele)
    combined.sort((a, b) => b.date.compareTo(a.date));

    return combined;
  }

  MyUser({required this.email, required this.name, required this.uid});
  factory MyUser.fromMap(Map<dynamic, dynamic> data, String uid) {
    return MyUser(uid: uid, name: data['name'], email: data['email']);
  }
  double getBalance() {
    return getIncome() - getExpense();
  }

  void addCategory(MyCategory category) {
    categories.add(category);
  }

  double getIncome() {
    double totalIncome = 0;
    for (var incomeItem in incomes) {
      totalIncome += incomeItem.amount;
    }
    return totalIncome;
  }

  double getExpense() {
    double totalExpense = 0;
    for (var expenseItem in expenses) {
      totalExpense += expenseItem.amount;
    }
    return totalExpense;
  }
}
