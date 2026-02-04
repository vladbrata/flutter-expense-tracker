import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GreetingsWidget extends StatelessWidget {
  const GreetingsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.globalAccentColor,
                ),
                const SizedBox(width: 10),
                Text(
                  'Hello, ${user?.name}',
                  style: const TextStyle(
                    color: AppColors.globalTextMainColor,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    authService.value.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                  color: AppColors.globalTextMainColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
