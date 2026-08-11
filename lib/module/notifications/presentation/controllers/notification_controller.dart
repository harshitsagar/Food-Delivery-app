import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';

class NotificationController extends GetxController {
  void goToHome() {
    Get.offAllNamed(AppRoute.home);
  }
}
