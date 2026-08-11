import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/save_user_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final SaveUserUseCase saveUserUseCase;
  final GetUserUseCase getUserUseCase;

  LoginController(
    this.loginUseCase,
    this.googleLoginUseCase,
    this.saveUserUseCase,
    this.getUserUseCase,
  );

  final useremailController = TextEditingController();
  final userpasswordController = TextEditingController();
  
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

      String? wallet = await SharedPreferenceHelper.getUserWallet();

      final userEntity = UserEntity(
        id: user.uid,
        name: user.displayName ?? TextConst.googleUser,
        email: user.email ?? TextConst.defaultEmail,
        wallet: wallet ?? "0",
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

  Future<void> userLogin(BuildContext context) async {
    String email = useremailController.text.trim();
    String password = userpasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(TextConst.error, TextConst.enterEmailPassword, backgroundColor: ColorConst.red, colorText: ColorConst.white);
      return;
    }

    try {
      loading.value = true;
      final userCredential = await loginUseCase.execute(email, password);
      final user = userCredential.user;

      if (user != null) {
        final existingUser = await getUserUseCase.execute(user.uid);

        if (existingUser == null) {
          final newUser = UserEntity(
            id: user.uid,
            name: email.split('@')[0],
            email: email,
            wallet: "0",
            loginType: "Email",
          );
          await saveUserUseCase.execute(newUser);
          
          await SharedPreferenceHelper.saveUserName(newUser.name);
          await SharedPreferenceHelper.saveUserEmail(newUser.email);
          await SharedPreferenceHelper.saveUserWallet(newUser.wallet);
          await SharedPreferenceHelper.saveUserLOGIN(newUser.loginType);
        } else {
          await SharedPreferenceHelper.saveUserName(existingUser.name);
          await SharedPreferenceHelper.saveUserEmail(existingUser.email);
          await SharedPreferenceHelper.saveUserWallet(existingUser.wallet);
          await SharedPreferenceHelper.saveUserLOGIN(existingUser.loginType);
        }

        await SharedPreferenceHelper.saveUserId(user.uid);

        loading.value = false;
        Get.offAllNamed(AppRoute.notifications);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  @override
  void onClose() {
    useremailController.dispose();
    userpasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
