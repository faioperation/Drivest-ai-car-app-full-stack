import 'package:flutter/material.dart';
import 'home/combined_home_page.dart';
import 'home/pages/ai_chat_page.dart';
import 'home/pages/compare_selection_page.dart';
import 'home/pages/profile/profile_page.dart';
import 'home/pages/saved_page.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CombinedHomePage(),
    CompareSelectionPage(),
    SavedPage(),
    const AiChatPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _RoundedBottomNavBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _RoundedBottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _RoundedBottomNavBar({required this.index, required this.onTap});

  static const _primary = Color(0xff015093);
  static const _grey = Color(0xFF8A8A8A);

  Widget _item(IconData icon, String label, int i) {
    final selected = index == i;
    final color = selected ? _primary : _grey;
    final weight = selected ? FontWeight.w600 : FontWeight.w400;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: weight)),
            ],
          ),
        ),
      ),
    );
  }

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
          children: [
            _item(Icons.home, 'Home', 0),
            _item(Icons.compare, 'Compare', 1),
            _item(Icons.bookmark, 'Saved', 2),
            _item(Icons.chat, 'AI Chat', 3),
            _item(Icons.person_2_outlined, 'Profile', 4),
          ],
        ),
      ),
    );
  }
}
