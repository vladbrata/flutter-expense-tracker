import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final String email;
  final String name;
  final String uid;

  MyUser({required this.email, required this.name, required this.uid});
  factory MyUser.fromMap(Map<dynamic, dynamic> data, String uid) {
    return MyUser(uid: uid, name: data['name'], email: data['email']);
  }
}
