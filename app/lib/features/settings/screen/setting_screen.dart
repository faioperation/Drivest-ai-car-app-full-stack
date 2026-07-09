import 'package:drivest_office/features/auth/screen/sign_in_screen.dart';
import 'package:drivest_office/home/pages/profile/refund_policy.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../home/pages/ai_chat_page.dart';
import '../../../home/pages/compare_selection_page.dart';
import '../../../home/pages/saved_page.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../auth/services/auth_service.dart';
import 'change_password_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Settings"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(Icons.key, color: Color(0xff015093)),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff333333),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 24,
                      color: Color(0xff015093),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    tileColor: Colors.white,
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Color(0xff015093),
                    ),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff333333),
                      ),
                    ),
                    onTap: () {
                      final scaffoldContext = context; // SAVE CONTEXT BEFORE DIALOG

                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text("Confirm Delete Account"),
                            content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(dialogContext); // close dialog

                                  final success = await AuthService().deleteAccount();

                                  if (success) {
                                    // show snackbar safely
                                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                      const SnackBar(
                                        content: Text("User account deleted successfully"),
                                        duration: Duration(milliseconds: 800),
                                      ),
                                    );

                                    await Future.delayed(const Duration(milliseconds: 800));

                                    if (!mounted) return;

                                    Navigator.of(scaffoldContext, rootNavigator: true)
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                                          (route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                      const SnackBar(
                                        content: Text("Failed to delete account. Try again."),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Delete Account",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },

                  ),
                ),
              ],
            ),
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
}
