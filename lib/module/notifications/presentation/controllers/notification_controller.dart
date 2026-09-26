import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/push_notification_service.dart';

class NotificationController extends GetxController {
  Future<void> turnOnNotifications() async {
    // Navigate instantly for snappy UX, while requesting permission & fetching token in background
    goToHome();
    PushNotificationService.requestPermissionAndGetToken();
  }

  void goToHome() {
    Get.offAllNamed(AppRoute.home);
  }
}
