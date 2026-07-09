import 'package:drivest_office/home/pages/ai_chat_page.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/profile_page_app_bar.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffF6E8EC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomNavItem(Icons.home, 'Home', 0),
            _bottomNavItem(Icons.compare, 'Compare', 1),
            _bottomNavItem(Icons.bookmark, 'Saved', 2),
            _bottomNavItem(Icons.chat, 'AI Chat', 3),
            _bottomNavItem(Icons.person, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xff015093) : Colors.grey[600];
    final fontWeight = isSelected ? FontWeight.w600 : FontWeight.w400;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RefundPolicy extends StatelessWidget {
  const RefundPolicy({super.key});

  static const primary = Color(0xff015093);

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 4;

    return Scaffold(
      appBar: DrivestAppBar(title: "Refund Policy"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ' 1. General Drivest aims for customer satisfaction. If you are not satisfied with a purchase or subscription, please contact us at drivestbelgium@gmail.com.',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    ' 2. Digital products and subscriptions - Purchases of digital content or subscriptions are generally non-refundable once access has been granted. - Exceptions may be made for technical issues or duplicate payments.',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    ' 3. Procedure To request a refund, send an email within 14 days of purchase including: - Full name User ID or transaction ID - Reason for request',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    ' After review, we will respond within 7 working days. If approved, the refund will be processed to your original payment method',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400, color: Color.fromRGBO(51, 51, 51, 1)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          CustomBottomNavBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
              } else if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CompareSelectionPage()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPage()));
              }
              else if(index == 3){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AiChatPage()));
              }
            },
          ),
        ],
      ),
    );
  }
}
