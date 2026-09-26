import 'package:get/get.dart';
import 'package:quick_eats_app/module/main_navigation/presentation/controllers/navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
