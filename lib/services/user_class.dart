import 'package:expense_tracker/services/category_class.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final String email;
  final String name;
  final String uid;
  List<MyCategory> categories = [];

  MyUser({required this.email, required this.name, required this.uid});
  factory MyUser.fromMap(Map<dynamic, dynamic> data, String uid) {
    return MyUser(uid: uid, name: data['name'], email: data['email']);
  }
  int getBalance() {
    return 0;
  }

  void addCategory(MyCategory category) {
    categories.add(category);
  }
}
