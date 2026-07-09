import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Privacy Policy "),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " At Drivest, we value the protection of your personal data. This policy explains what information we collect, why we collect it, and how we protect it.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildNumberedItem(
                  "1. Controller Drivest Email: drivestbelgium@gmail.com"),
              _buildNumberedItem(
                  "2. Information we collect We may collect the following data when you use our app: - Name andcontact details (email, phone number) - Payment and billing information - App usage data (searchbehavior, preferences)"),
              _buildNumberedItem(
                  " 3. Purpose We use your data to: - Create and manage user accounts - Process payments andtransactions - Provide customer support and communication - Analyze app usage and improve ourservices"),
              _buildNumberedItem(
                  " 4. Data sharing We only share personal data when necessary for: - Payment processing (viatrusted providers such as Stripe or Mollie) - Legal obligations"),
              _buildNumberedItem(
                  " 5. Data retention We store personal data as long as necessary for the purposes stated or asrequired by law."),
              _buildNumberedItem(
                  "6. Security Drivest takes technical and organizational measures to protect your data from loss,misuse, or unauthorized access."),
              _buildNumberedItem(
                  "7. Your rights You have the right to access, correct, or delete your data. Contact us at drivestbelgium@gmail.com for any request.")
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => CompareSelectionPage()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPage()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => AiChatPage()));
        },
      ),
    );
  }

  Widget _buildNumberedItem( String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
