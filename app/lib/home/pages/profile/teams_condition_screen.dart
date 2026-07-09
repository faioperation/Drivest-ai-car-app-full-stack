import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  int _selectedIndex = 4;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Terms & Condition"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " These terms and conditions apply to the use of the Drivest app and all related services.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              _buildNumberedItem(
                  "1. Definitions - Drivest: provider of the app and related services. - User: any person using the app or making a purchase."),
              _buildNumberedItem(
                  " 2. Acceptance By using the app, you agree to these terms and conditions."),
              _buildNumberedItem(
                  " 3. Services Drivest provides data, analytics, and information tools related to vehicle trading opportunities. Information is provided for support purposes and should not be considered financial advice."),
              _buildNumberedItem(
                  "4. Payments All payments within the app are processed securely through our payment partners.Prices include VAT unless otherwise stated. By completing a payment, you also agree to thepayment provider’s conditions."),
              _buildNumberedItem(
                  "5. Liability Drivest shall not be liable for any damages resulting from the use of the app or provided information. Users remain fully responsible for their buying and selling decisions."),
              _buildNumberedItem(""
                  "6. Intellectual Property All app content, logos, and data remain the intellectual property of Drivest.Copying or reproducing without written consent is prohibited."),
              _buildNumberedItem(""
                  " 7. Governing Law These terms are governed by Belgian law. Disputes shall be settled in the courtsof Antwerp, Belgium.")
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
                fontSize: 14,
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
