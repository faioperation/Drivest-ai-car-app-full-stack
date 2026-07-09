import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/network/auth_utils.dart';
import '../model/notification_model.dart';
import '../../../app/urls.dart';

class NotificationService {
  static Future<List<NotificationModel>> getNotifications(String token) async {
    final url = Uri.parse(Urls.notificationUrl);

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401 ||
        response.statusCode == 402 ||
        response.statusCode == 403) {
      await AuthUtils.handleUnauthorized();
      throw Exception("Unauthorized! Logging out...");
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List data = body['data'];
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  static Future<int> getNotificationCount(String token) async {
    final notifications = await getNotifications(token);
    return notifications.where((n) => !n.isRead).length;
  }

  static Future<void> markAsRead(String id, String token) async {
    final url = Uri.parse(Urls.notificationReadUrl);

    final body = jsonEncode({
      "ids": [id]
    });

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );

    if (response.statusCode == 401 ||
        response.statusCode == 402 ||
        response.statusCode == 403) {
      await AuthUtils.handleUnauthorized();
      throw Exception("Unauthorized! Logging out...");
    }

    if (response.statusCode != 200) {
      throw Exception("Failed to mark notification as read");
    }
  }

  static Future<void> markAllAsRead(String token, List<String> allIds) async {
    final url = Uri.parse(Urls.notificationAllReadUrl);


    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401 ||
        response.statusCode == 402 ||
        response.statusCode == 403) {
      await AuthUtils.handleUnauthorized();
      throw Exception("Unauthorized! Logging out...");
    }

    if (response.statusCode != 200) {
      throw Exception("Failed to mark all notifications as read");
    }
  }


}
