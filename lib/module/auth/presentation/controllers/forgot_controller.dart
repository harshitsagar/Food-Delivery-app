import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotController extends GetxController {
  final emailController = TextEditingController();
  RxBool loading = false.obs;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      loading.value = false;
      Get.snackbar("Success", "Password Reset Email has been sent to your email!", 
          backgroundColor: Colors.white, colorText: Colors.black);
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
