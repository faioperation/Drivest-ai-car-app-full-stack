import 'package:flutter/material.dart';
import 'notification_service.dart';
import '../../auth/services/auth_service.dart';

class NotificationCountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int value) {
    _count = value;
    notifyListeners();
  }

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  // Refresh count from backend
  Future<void> refreshCount(String token) async {
    final notifications = await NotificationService.getNotifications(token);
    _count = notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }
}
