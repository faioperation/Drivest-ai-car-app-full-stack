import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/network/user_provider.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/notifications/services/notification_count_provider.dart';
import '../../features/notifications/screen/notification_screen.dart';

class TopAppBar extends StatefulWidget {
  final double appBarHeight;
  const TopAppBar({super.key, required this.appBarHeight});

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<UserProvider>(context, listen: false).fetchUserProfile();

      String? token = await AuthService().getToken();
      if (token != null) {
        await context.read<NotificationCountProvider>().refreshCount(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifCount = Provider.of<NotificationCountProvider>(context).count;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Container(
              height: widget.appBarHeight,
              color: const Color.fromRGBO(1, 80, 147, 1),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        final userData = userProvider.userData;
        final displayName = userData?['name'] ?? 'Guest';
        final displayEmail = userData?['email'] ?? 'email@gmail.com';

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Container(
            color: const Color.fromRGBO(1, 80, 147, 1),
            child: Stack(
              children: [
                Positioned(
                  top: widget.appBarHeight * 0.25,
                  left: 20,
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: ClipOval(
                          child: userData?['image'] != null &&
                              userData!['image'].isNotEmpty
                              ? Image.network(
                            userData['image'],
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/profile_img.jpg',
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                              : Image.asset(
                            'assets/images/profile_img.jpg',
                            width: 42,
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $displayName',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            displayEmail,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: widget.appBarHeight * 0.25,
                  right: 20,
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            size: 32, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );

                          // Refresh unread count after returning
                          String? token = await AuthService().getToken();
                          if (token != null) {
                            await context.read<NotificationCountProvider>().refreshCount(token);
                          }
                        },
                      ),
                      if (notifCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notifCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
