import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:drivest_office/features/auth/services/auth_service.dart';
import 'package:drivest_office/home/pages/payment_page.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import 'package:drivest_office/app/asset_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      remember: _rememberMe,
    );

    if (!mounted) return;

    switch (result["status"]) {
      case "DEACTIVATED":
        _showError("This account is deactivated. Please contact support.");
        break;
      case "Pending":
        _showError("Your account is pending admin approval.");
        break;

      case "TRIAL_EXPIRED":
        String tempToken = result["temp_token"];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentPage(tempToken: tempToken),
          ),
        );
        break;

      case "SUCCESS":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainBottomNavScreen()),
        );
        break;

      default:
        _showError("Invalid email or password");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(email: _emailController.text.trim()),
      ),
    );
  }

  void _onSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header
            Container(
              color: const Color(0xFF004E92),
              width: double.infinity,
              height: size.height * 0.30,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => exit(0),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        AssetPaths.appLogoSvg,
                        height: size.height * 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Login Form
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Welcome to Drivest",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Drive the deal you deserve",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF5C5C5C)),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        validator: (val) => val == null || val.isEmpty ? "Enter email" : null,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (val) => val == null || val.isEmpty ? "Enter password" : null,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Remember Me
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                activeColor: const Color(0xFF004E92),
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          GestureDetector(
                            onTap: _onForgotPassword,
                            child: const Text("Forgot password?", style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004E92),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isLoading ? null : _onSignIn,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Sign in", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Sign Up link
                      GestureDetector(
                        onTap: _onSignUp,
                        child: const Text.rich(
                          TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(color: Color(0xFF015093), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
