import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/module/home/presentation/controllers/home_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Also save to history in background if needed
  try {
    if (message.notification != null) {
      await SharedPreferenceHelper.init();
      String title = message.notification?.title ?? "New Update";
      String body = message.notification?.body ?? "";
      String time = DateTime.now().toString().substring(11, 16);

      List<String> history = SharedPreferenceHelper.getNotificationHistory();
      history.insert(0, "$title|$body|$time");
      if (history.length > 50) history = history.sublist(0, 50);
      await SharedPreferenceHelper.saveNotificationHistory(history);

      int currentUnread = SharedPreferenceHelper.getUnreadNotificationCount();
      await SharedPreferenceHelper.saveUnreadNotificationCount(currentUnread + 1);
    }
  } catch (e) {
    print("Error in background handler history save: $e");
  }
}

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Set Background Message Handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Initialize Local Notifications for Foreground display
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          Get.toNamed(response.payload!);
        }
      },
    );

    // Create Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 3. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        String title = notification.title ?? "New Update";
        String body = notification.body ?? "";
        String time = DateTime.now().toString().substring(11, 16);

        // Save to history
        List<String> history = SharedPreferenceHelper.getNotificationHistory();
        history.insert(0, "$title|$body|$time");
        if (history.length > 50) history = history.sublist(0, 50);
        SharedPreferenceHelper.saveNotificationHistory(history);

        // Increment unread count
        int currentUnread = SharedPreferenceHelper.getUnreadNotificationCount();
        SharedPreferenceHelper.saveUnreadNotificationCount(currentUnread + 1);
        if (Get.isRegistered<HomeController>()) {
          HomeController.to.loadUnreadCount();
        }

        _localNotificationsPlugin.show(
          notification.hashCode,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
          payload: message.data['route'] ?? AppRoute.home,
        );
      }
    });

    // 4. Handle App opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("App opened from terminated state by notification");
        Get.toNamed(AppRoute.home);
      }
    });

    // 5. Handle App opened from background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background by notification");
      Get.toNamed(AppRoute.home);
    });
  }

  // Request permission and get token on demand (non-blocking)
  static Future<bool> requestPermissionAndGetToken() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        _fetchTokenAsync();
        return true;
      }
    } catch (e) {
      print("Error requesting permission: $e");
    }
    return false;
  }

  static void _fetchTokenAsync() async {
    try {
      if (GetPlatform.isIOS) {
        String? apnsToken;
        for (int i = 0; i < 5; i++) {
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) break;
          await Future.delayed(const Duration(seconds: 1));
        }
        if (apnsToken != null) {
          String? token = await _firebaseMessaging.getToken();
          print("FCM Token: $token");
        } else {
          print("APNs token could not be retrieved.");
        }
      } else {
        String? token = await _firebaseMessaging.getToken();
        print("FCM Token: $token");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }
}
