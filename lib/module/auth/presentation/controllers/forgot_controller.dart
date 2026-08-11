import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';

class ForgotController extends GetxController {
  final emailController = TextEditingController();
  RxBool loading = false.obs;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(TextConst.error, TextConst.enterYourEmail, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      loading.value = false;
      Get.snackbar(TextConst.success, TextConst.passwordResetEmailSent, 
          backgroundColor: Colors.white, colorText: Colors.black);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
