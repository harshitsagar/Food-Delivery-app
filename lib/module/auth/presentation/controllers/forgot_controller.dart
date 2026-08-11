import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import '../../domain/usecases/reset_password_usecase.dart';

class ForgotController extends GetxController {
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotController(this.resetPasswordUseCase);

  final emailController = TextEditingController();
  RxBool loading = false.obs;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(TextConst.error, TextConst.enterYourEmail, backgroundColor: ColorConst.red, colorText: ColorConst.white);
      return;
    }

    try {
      loading.value = true;
      await resetPasswordUseCase.execute(email);
      loading.value = false;
      Get.snackbar(TextConst.success, TextConst.passwordResetEmailSent, 
          backgroundColor: ColorConst.white, colorText: ColorConst.black);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
