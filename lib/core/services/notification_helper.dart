import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/module/home/presentation/controllers/home_controller.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> showInAppNotification({
    required String title,
    required String body,
    String? route,
  }) async {
    String time = DateTime.now().toString().substring(11, 16);

    // 1. Save to notification history
    List<String> history = SharedPreferenceHelper.getNotificationHistory();
    history.insert(0, "$title|$body|$time");
    if (history.length > 50) history = history.sublist(0, 50);
    await SharedPreferenceHelper.saveNotificationHistory(history);

    // 2. Increment unread badge count
    int currentUnread = SharedPreferenceHelper.getUnreadNotificationCount();
    await SharedPreferenceHelper.saveUnreadNotificationCount(currentUnread + 1);
    if (Get.isRegistered<HomeController>()) {
      HomeController.to.loadUnreadCount();
    }

    // 3. Show local banner notification
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important food delivery notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
      payload: route ?? AppRoute.home,
    );
  }
}
