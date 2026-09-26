import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 100.h, right: 20.w),
                child: Text(
                  TextConst.notificationTitle,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorConst.black,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  TextConst.notificationSubtitle,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorConst.grey,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Image.asset(
                ImageConst.uncleJee,
                height: 320.h,
                width: 320.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 40.h, right: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.turnOnNotifications(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.deepOrange,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(
                      TextConst.turnOnNotification,
                      style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorConst.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => controller.goToHome(),
                child: Text(
                  TextConst.notNow,
                  style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w700, color: ColorConst.deepOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
