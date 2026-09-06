import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/module/home/presentation/controllers/home_controller.dart';

class NotificationHistoryController extends GetxController {
  var notifications = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        HomeController.to.resetUnreadCount();
      } else {
        SharedPreferenceHelper.saveUnreadNotificationCount(0);
      }
    });
  }

  void loadNotifications() {
    List<String> rawHistory = SharedPreferenceHelper.getNotificationHistory();
    notifications.value = rawHistory.map((item) {
      List<String> parts = item.split('|');
      return {
        "title": parts.isNotEmpty ? parts[0] : "Notification",
        "body": parts.length > 1 ? parts[1] : "",
        "time": parts.length > 2 ? parts[2] : "",
      };
    }).toList();
  }

  void clearNotifications() {
    SharedPreferenceHelper.saveNotificationHistory([]);
    notifications.clear();
  }
}
