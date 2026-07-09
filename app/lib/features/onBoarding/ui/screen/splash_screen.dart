import 'package:drivest_office/features/auth/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/app_logo.dart';
import 'on_boarding_screen_one.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // 🔥 Token found → Go to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainBottomNavScreen()),
      );
    } else {
      // 🔥 No token → Show Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreenOne()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF015093),
      body: SafeArea(
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}
