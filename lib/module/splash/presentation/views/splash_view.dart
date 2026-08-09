import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/core/widget/circular_loader.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    Timer(const Duration(seconds: 3), () {
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
      debugPrint("Splash Navigation Error: $e");
      Get.offAllNamed(AppRoute.onboarding); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ColorConst.screenBackgroundGradient,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Image.asset(
                      'images/splash_logo.png',
                      height: 0.22.sh,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          ColorConst.orangeGradientStart,
                          ColorConst.orangeGradientEnd,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        'Quick Eats',
                        style: GoogleFonts.inter(
                          fontSize: 42.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorConst.white,
                          letterSpacing: -0.9,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Center(
                child: CircleDotLoader(
                  color: ColorConst.orangeGradientStart,
                  size: 38.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
