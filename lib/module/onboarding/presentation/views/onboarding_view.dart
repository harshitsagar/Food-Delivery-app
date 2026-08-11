import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/widget/content_model.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ColorConst.screenBackgroundGradient,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: contents.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 60.h),
                            Image.asset(
                              contents[i].image,
                              height: 0.45.sh,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              contents[i].title1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: ColorConst.onboardingTitle,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              contents[i].title2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: ColorConst.orangeGradientStart,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 2.5.h,
                                  width: 25.w,
                                  decoration: BoxDecoration(
                                    color: ColorConst.orangeGradientStart,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Container(
                                  height: 4.h,
                                  width: 4.w,
                                  decoration: const BoxDecoration(
                                    color: ColorConst.onboardingDot,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              contents[i].description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: ColorConst.onboardingDesc,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (index) => Obx(() => buildDot(index, context)),
                    ),
                  ),
                ),
                Obx(() => GestureDetector(
                  onTap: () {
                    if (controller.currentIndex.value == contents.length - 1) {
                      controller.completeOnboarding();
                    } else {
                      controller.next();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorConst.orangeGradientStart,
                          ColorConst.orangeGradientEnd,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConst.orangeGradientStart.withOpacity(0.3),
                          blurRadius: 15.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    height: 65.h,
                    margin: EdgeInsets.symmetric(horizontal: 45.w, vertical: 30.h),
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          controller.currentIndex.value == contents.length - 1 ? TextConst.getStarted : TextConst.next,
                          style: GoogleFonts.inter(
                            color: ColorConst.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Positioned(
                          right: 25.w,
                          child: Icon(
                            Icons.arrow_forward,
                            color: ColorConst.white,
                            size: 24.r,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            // Skip button
            Positioned(
              top: 50.h,
              right: 25.w,
              child: TextButton(
                onPressed: () => controller.completeOnboarding(),
                child: Text(
                  TextConst.skip,
                  style: GoogleFonts.inter(
                    color: ColorConst.onboardingDesc,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Back button
            Obx(() => controller.currentIndex.value > 0
                ? Positioned(
                    top: 50.h,
                    left: 20.w,
                    child: IconButton(
                      onPressed: () => controller.previous(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: ColorConst.onboardingTitle,
                        size: 22.r,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 12.h,
      width: 12.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: controller.currentIndex.value == index
            ? ColorConst.orangeGradientStart
            : ColorConst.onboardingInactiveDot,
      ),
    );
  }
}
