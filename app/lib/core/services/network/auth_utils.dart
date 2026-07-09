import 'package:drivest_office/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../features/auth/screen/sign_in_screen.dart';  // navigatorKey import

class AuthUtils {
  static Future<void> handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
          (route) => false,
    );
  }
}
