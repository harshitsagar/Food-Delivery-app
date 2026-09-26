import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/save_user_usecase.dart';

class SignupController extends GetxController {
  final SignUpUseCase signUpUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final SaveUserUseCase saveUserUseCase;

  SignupController(
    this.signUpUseCase,
    this.googleLoginUseCase,
    this.saveUserUseCase,
  );

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  RxBool obscureText = true.obs;
  RxBool loading = false.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      loading.value = true;
      final userCredential = await googleLoginUseCase.execute();

      if (userCredential == null) {
        loading.value = false;
        return;
      }

      final user = userCredential.user;
      if (user == null) {
        loading.value = false;
        return;
      }

      final userEntity = UserEntity(
        id: user.uid,
        name: user.displayName ?? TextConst.googleUser,
        email: user.email ?? TextConst.defaultEmail,
        wallet: "0",
        loginType: "Google",
      );

      await saveUserUseCase.execute(userEntity);

      await SharedPreferenceHelper.saveUserName(userEntity.name);
      await SharedPreferenceHelper.saveUserEmail(userEntity.email);
      await SharedPreferenceHelper.saveUserWallet(userEntity.wallet);
      await SharedPreferenceHelper.saveUserId(userEntity.id);
      await SharedPreferenceHelper.saveUserLOGIN(userEntity.loginType);

      loading.value = false;
      Get.offAllNamed(AppRoute.notifications);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  Future<void> registration(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar(TextConst.error, TextConst.fillAllFields, backgroundColor: ColorConst.red, colorText: ColorConst.white);
      return;
    }

    try {
      loading.value = true;
      final userCredential = await signUpUseCase.execute(email, password);
      final userId = userCredential.user!.uid;

      final userEntity = UserEntity(
        id: userId,
        name: name,
        email: email,
        wallet: "0",
        loginType: "Email",
      );

      await saveUserUseCase.execute(userEntity);

      await SharedPreferenceHelper.saveUserName(name);
      await SharedPreferenceHelper.saveUserEmail(email);
      await SharedPreferenceHelper.saveUserWallet('0');
      await SharedPreferenceHelper.saveUserId(userId);
      await SharedPreferenceHelper.saveUserLOGIN("Email");

      loading.value = false;
      Get.offAllNamed(AppRoute.notifications);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
