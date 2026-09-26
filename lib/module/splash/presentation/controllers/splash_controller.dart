import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/app_constants.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    Timer(const Duration(seconds: AppConstants.splashDuration), () {
      _checkNavigation();
    });
  }

  Future<void> _checkNavigation() async {
    try {
      bool? isOnboardingSeen = await SharedPreferenceHelper.getIsOnboarding();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Get.offAllNamed(AppRoute.home);
      } else {
        if (isOnboardingSeen == true) {
          Get.offAllNamed(AppRoute.login);
        } else {
          Get.offAllNamed(AppRoute.onboarding);
        }
      }
    } catch (e) {
      debugPrint("${TextConst.splashNavigationError}$e");
      Get.offAllNamed(AppRoute.onboarding); // Fallback
    }
  }
}
