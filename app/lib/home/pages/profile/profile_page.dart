import 'package:drivest_office/features/auth/screen/sign_in_screen.dart';
import 'package:drivest_office/features/settings/screen/setting_screen.dart';
import 'package:drivest_office/home/pages/payment_page.dart';
import 'package:drivest_office/home/pages/profile/invoice_screen.dart';
import 'package:drivest_office/home/pages/profile/teams_condition_screen.dart';
import 'package:drivest_office/home/pages/profile/refund_policy.dart';
import 'package:drivest_office/home/pages/profile/help_&_feedback_page.dart';
import 'package:drivest_office/home/pages/profile/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/network/user_provider.dart';
import '../../../main_bottom_nav_screen.dart';
import '../saved_page.dart';
import 'privacy_policy_screen.dart';
import '../../../features/auth/services/auth_service.dart';

const _primary = Color(0xff015093);
const _bg = Color(0xffF7F8FA);
const _border = Color(0xffE8EDF3);
const _textDark = Color(0xff1F2937);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const primary = Color(0xff015093);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
                  (route) => false,
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: SavedPage.primary),
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: _primary));
          }

          final userData = userProvider.userData;
          final displayName = userData?['name'] ?? 'Guest';
          final displayEmail = userData?['email'] ?? 'guest@gmail.com';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: userData != null && userData['image'] != null && userData['image'].isNotEmpty
                          ? Image.network(
                        userData['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(color: _primary));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/profile_img.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.asset(
                        'assets/images/profile_img.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(displayName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(51, 51, 51, 1))),
                    const SizedBox(height: 4),
                    Text(displayEmail,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(118, 118, 118, 1))),
                  ],
                ),
                const SizedBox(height: 16),

                _SectionCard(
                  children: [
                    _OptionTile(
                      icon: Icons.person_outline,
                      title: 'My Profile',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyProfilePage()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.info_outline,
                      title: 'Refund Policy',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RefundPolicy()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.help_outline,
                      title: 'Help & Feedback',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HelpAndFeedbackPage()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SettingScreen()));
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                const Text('More',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                _SectionCard(
                  children: [
                    _OptionTile(
                      icon: Icons.description_outlined,
                      title: 'Invoice',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => InvoiceScreen()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.report_gmailerrorred,
                      title: 'Terms & Condition',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TermsAndConditionScreen()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
                      },
                    ),
                    const _TileDivider(),
                    _OptionTile(
                      icon: Icons.logout,
                      title: 'Log Out',
                      danger: true,
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: _primary),
                          ),
                        );

                        try {
                          await AuthService().signOut();

                          if (!context.mounted) return;

                          Navigator.of(context, rootNavigator: true).pop();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const SignInScreen()),
                                (route) => false,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Logout failed: $e")),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: _border);
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: danger ? const Color(0xffD7263D) : _textDark,
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: _primary, size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: textStyle)),
            const Icon(Icons.chevron_right, color: _primary, size: 22),
          ],
        ),
      ),
    );
  }
}