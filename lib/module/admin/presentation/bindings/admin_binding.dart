import 'package:get/get.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
