import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';

class HomeAdminView extends StatelessWidget {
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: ColorConst.screenBackgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offAllNamed(AppRoute.home),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: ColorConst.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: ColorConst.black,
                          size: 20.r,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          TextConst.adminHome,
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 36.w),
                  ],
                ),
                SizedBox(height: 30.h),

                // Add Food Items Action Card
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoute.addFood),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: ColorConst.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            ImageConst.foodBanner,
                            height: 85.h,
                            width: 85.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            TextConst.addFoodItems,
                            style: GoogleFonts.poppins(
                              color: ColorConst.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5722),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: ColorConst.white,
                            size: 16.r,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
