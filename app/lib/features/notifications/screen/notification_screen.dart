import 'package:drivest_office/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/notification_model.dart';
import '../services/notification_count_provider.dart';
import '../services/notification_service.dart';
import 'notification_detail_screen.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  fetchNotifications() async {
    try {
      token = await AuthService().getToken();

      if (token == null) {
        print("Token not found!");
        setState(() => isLoading = false);
        return;
      }

      final list = await NotificationService.getNotifications(token!);

      final unreadCount = list.where((n) => !n.isRead).length;
      final provider = context.read<NotificationCountProvider>();
      provider.setCount(unreadCount);

      setState(() {
        notifications = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  void markAllNotifications() async {
    if (token == null) return;

    // get all notification IDs
    final allIds = notifications.map((e) => e.id).toList();

    // call backend API
    await NotificationService.markAllAsRead(token!, allIds);

    // update all items locally
    for (var n in notifications) {
      n.isRead = true;
    }

    // update provider count = 0
    final provider = context.read<NotificationCountProvider>();
    provider.setCount(0);

    // refresh UI
    setState(() {});
  }

  String formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(
        title: "Notifications",
        actions: [
          TextButton(
            onPressed: markAllNotifications,
            child: Text("Mark All Read"),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 16, color: Color(0xff333333)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Container(
                  decoration: BoxDecoration(
                    color: item.isRead
                        ? Colors.white
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(Icons.notifications, color: Colors.blue),
                    ),
                    title: Text(
                      "New Notification",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: item.isRead ? Colors.black87 : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      item.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: item.isRead ? Colors.black54 : Colors.black87,
                      ),
                    ),
                    trailing: Text(
                      formatTime(item.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    onTap: () async {
                      if (!item.isRead) {
                        item.isRead = true;

                        final provider = context
                            .read<NotificationCountProvider>();
                        provider.decrement();

                        if (token != null) {
                          await NotificationService.markAsRead(item.id, token!);

                          // 🔥 important: backend theke real count reload
                          await provider.refreshCount(token!);
                        }

                        setState(() {});
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationDetailScreen(
                            notification: item,
                            index: index + 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
