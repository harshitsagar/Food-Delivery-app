import 'package:get/get.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/login_controller.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/signup_controller.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/forgot_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgotController>(() => ForgotController());
  }
}
