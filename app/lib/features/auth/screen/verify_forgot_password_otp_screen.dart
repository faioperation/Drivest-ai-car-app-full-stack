import 'package:drivest_office/core/services/network/auth_api.dart';
import 'package:drivest_office/features/auth/screen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../app/asset_paths.dart';

class VerifyForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const VerifyForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<VerifyForgotPasswordOtpScreen> createState() =>
      _VerifyForgotPasswordOtpScreenState();
}

class _VerifyForgotPasswordOtpScreenState
    extends State<VerifyForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isVerifying = false;

  void _onVerify() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isVerifying = true);

      try {
        final response = await ApiService.verifyForgotPasswordOtp(
          widget.email,
          _otpController.text.trim(),
        );

        setState(() => _isVerifying = false);
        debugPrint("OTP verification response: $response");

        if (response['success'] == true ||
            (response['message'] != null &&
                response['message'].toString().toLowerCase().contains('success'))) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: widget.email),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Invalid OTP'),
            ),
          );
        }
      } catch (e) {
        setState(() => _isVerifying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }



  void _onResend() async {
    setState(() => _isVerifying = true);

    try {
      final response = await ApiService.forgotPassword(widget.email);
      setState(() => _isVerifying = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'OTP resent!')),
      );
    } catch (e) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF004E92),
              width: double.infinity,
              height: size.height * 0.50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        AssetPaths.appLogoSvg,
                        height: size.height * 0.30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Check your email",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "We sent a reset link to ${widget.email}.\nPlease enter the 6 digit code.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                      const SizedBox(height: 20),

                      PinCodeTextField(
                        controller: _otpController,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldWidth: 45,
                          fieldHeight: 50,
                          activeColor: Colors.blue,
                          selectedColor: Colors.blueAccent,
                          inactiveColor: Colors.grey,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        appContext: context,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Enter your 6 digit OTP';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _onResend,
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004E92),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 3,
                          ),
                          onPressed: _isVerifying ? null : _onVerify,
                          child: _isVerifying
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "Verify Code",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFFEFEFE),
                            ),
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
