import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/services/network/subscription_service.dart';
import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';

class PaymentPage extends StatefulWidget {
  final String tempToken;
  const PaymentPage({super.key, required this.tempToken});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final token = widget.tempToken;

    return Scaffold(
      appBar: const DrivestAppBar(title: "Subscribe to Continue"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your free trial has expired.\nPlease subscribe to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final url = await SubscriptionService.createSubscriptionUrl(token);
                  if (url != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StripePaymentWebView(url: url, tempToken: token)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to create payment session.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004E92),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Subscribe Now", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StripePaymentWebView extends StatelessWidget {
  final String url;
  final String tempToken;
  const StripePaymentWebView({super.key, required this.url, required this.tempToken});

  Future<void> _handlePaymentSuccess(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tempToken);
    await prefs.setBool('isSubscribed', true);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainBottomNavScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains("success")) {
              _handlePaymentSuccess(context);
              return NavigationDecision.prevent;
            } else if (request.url.contains("cancel")) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment Cancelled")),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: WebViewWidget(controller: controller),
    );
  }
}
