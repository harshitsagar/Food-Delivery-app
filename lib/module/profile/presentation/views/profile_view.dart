import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/profile/presentation/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
          child: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Top Curved Orange Banner & Profile Avatar Stack
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Orange Gradient Curved Top Banner (Extends into Status Bar)
                          Container(
                            height: 140.h + topPadding,
                            width: 1.sw,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF8A00), Color(0xFFFF5722)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(1.sw, 90.h),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5722).withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: topPadding + 15.h),
                              child: Text(
                                controller.name.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: ColorConst.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Profile Picture Avatar positioned on the curve
                          Positioned(
                            top: 65.h + topPadding,
                            child: GestureDetector(
                              onTap: () => controller.getImage(),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3.5.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60.r),
                                      child: Obx(() => controller.selectedImage.value != null
                                          ? Image.file(
                                              controller.selectedImage.value!,
                                              height: 110.r,
                                              width: 110.r,
                                              fit: BoxFit.cover,
                                            )
                                          : controller.profilePic.value.isEmpty
                                              ? Image.asset(
                                                  ImageConst.profileBoy,
                                                  height: 110.r,
                                                  width: 110.r,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  controller.profilePic.value,
                                                  height: 110.r,
                                                  width: 110.r,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                                    ImageConst.profileBoy,
                                                    height: 110.r,
                                                    width: 110.r,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                    ),
                                  ),
                                  // Camera Icon Badge
                                  Positioned(
                                    bottom: 2.r,
                                    right: 2.r,
                                    child: Container(
                                      padding: EdgeInsets.all(7.r),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF5722),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.15),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: ColorConst.white,
                                        size: 16.r,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60.h), // Spacing for avatar overlap

                      // Profile Items List
                      _buildProfileItem(Icons.person, TextConst.nameLabel, controller.name.value),
                      SizedBox(height: 14.h),
                      _buildProfileItem(Icons.email, TextConst.emailLabel, controller.email.value),
                      SizedBox(height: 14.h),
                      _buildSwitchItem(Icons.notifications, TextConst.notificationsLabel, controller.isNotificationsEnabled, (val) => controller.toggleNotifications(val)),
                      SizedBox(height: 14.h),
                      _buildSimpleItem(Icons.description, TextConst.termsCondition),
                      SizedBox(height: 14.h),
                      _buildActionItem(Icons.store, TextConst.sellerLogin, () {
                        Get.toNamed(AppRoute.adminLogin);
                      }),
                      SizedBox(height: 14.h),
                      _buildActionItem(Icons.delete, TextConst.deleteAccount, () => _showConfirmationDialog(TextConst.deleteAccount, TextConst.deleteConfirm, () => controller.deleteAccount())),
                      SizedBox(height: 14.h),
                      _buildActionItem(Icons.logout, TextConst.logOut, () => _showConfirmationDialog(TextConst.logout, TextConst.logoutConfirm, () => controller.logout())),
                      SizedBox(height: 95.h), // Bottom spacing for curved bottom navigation bar
                    ],
                  ),
                )),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF5722), size: 24.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 2.h),
                Text(value, style: GoogleFonts.poppins(color: ColorConst.black, fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleItem(IconData icon, String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF5722), size: 24.r),
          SizedBox(width: 16.w),
          Text(title, style: GoogleFonts.poppins(color: ColorConst.black, fontSize: 16.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, RxBool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF5722), size: 24.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(title, style: GoogleFonts.poppins(color: ColorConst.black, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ),
          Obx(() => Switch(
            value: value.value,
            activeThumbColor: const Color(0xFFFF5722),
            onChanged: onChanged,
          )),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF5722), size: 24.r),
            SizedBox(width: 16.w),
            Text(title, style: GoogleFonts.poppins(color: ColorConst.black, fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String title, String content, VoidCallback onConfirm) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0.r)),
        child: SizedBox(
          height: 250.h,
          child: Column(
            children: [
              Container(
                height: 90.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5722),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
                ),
                child: Center(child: Icon(Icons.help_outline, color: ColorConst.white, size: 50.r)),
              ),
              SizedBox(height: 16.h),
              Text(title, style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorConst.black)),
              SizedBox(height: 8.h),
              Text(content, style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700])),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(TextConst.no, style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey[700])),
                    onPressed: () => Get.back(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Text(TextConst.yes, style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.white)),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
