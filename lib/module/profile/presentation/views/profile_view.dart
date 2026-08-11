import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/profile/presentation/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 45.h, left: 20.w, right: 20.w),
                        height: 1.sh / 4.3,
                        width: 1.sw,
                        decoration: BoxDecoration(
                            color: ColorConst.black,
                            borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(1.sw, 105.h))),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 1.sh / 7),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(80.r),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80.r),
                              child: Obx(() => GestureDetector(
                                onTap: () => controller.getImage(),
                                child: controller.selectedImage.value != null
                                    ? Image.file(controller.selectedImage.value!, height: 150.r, width: 150.r, fit: BoxFit.cover)
                                    : controller.profilePic.value.isEmpty
                                        ? Image.asset(ImageConst.profileBoy, height: 120.r, width: 120.r, fit: BoxFit.cover)
                                        : Image.network(controller.profilePic.value, height: 150.r, width: 150.r, fit: BoxFit.cover),
                              )),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 70.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.name.value,
                              style: TextStyle(color: ColorConst.white, fontSize: 25.sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildProfileItem(Icons.person, TextConst.nameLabel, controller.name.value),
                  SizedBox(height: 20.h),
                  _buildProfileItem(Icons.email, TextConst.emailLabel, controller.email.value),
                  SizedBox(height: 20.h),
                  _buildSimpleItem(Icons.description, TextConst.termsCondition),
                  SizedBox(height: 20.h),
                  _buildActionItem(Icons.person, TextConst.sellerLogin, () {
                    Get.toNamed(AppRoute.adminLogin);
                  }),
                  SizedBox(height: 20.h),
                  _buildActionItem(Icons.delete, TextConst.deleteAccount, () => _showConfirmationDialog(TextConst.deleteAccount, TextConst.deleteConfirm, () => controller.deleteAccount())),
                  SizedBox(height: 20.h),
                  _buildActionItem(Icons.logout, TextConst.logOut, () => _showConfirmationDialog(TextConst.logout, TextConst.logoutConfirm, () => controller.logout())),
                  SizedBox(height: 40.h),
                ],
              ),
            )),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Material(
        elevation: 5, borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
          decoration: BoxDecoration(color: ColorConst.white, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              Icon(icon, color: ColorConst.black, size: 24.r),
              SizedBox(width: 20.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: ColorConst.black, fontSize: 18.sp, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(color: ColorConst.black, fontSize: 18.sp, fontWeight: FontWeight.w600)),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleItem(IconData icon, String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Material(
        elevation: 5, borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
          decoration: BoxDecoration(color: ColorConst.white, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              Icon(icon, color: ColorConst.black, size: 24.r),
              SizedBox(width: 20.w),
              Text(title, style: TextStyle(color: ColorConst.black, fontSize: 20.sp, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Material(
          elevation: 5, borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            decoration: BoxDecoration(color: ColorConst.white, borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Icon(icon, color: ColorConst.black, size: 24.r),
                SizedBox(width: 20.w),
                Text(title, style: TextStyle(color: ColorConst.black, fontSize: 20.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
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
                height: 100.h,
                decoration: BoxDecoration(color: ColorConst.teal, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
                child: Center(child: Icon(Icons.check_circle, color: ColorConst.white, size: 60.r)),
              ),
              SizedBox(height: 20.h),
              Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Text(content, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(child: Text(TextConst.no, style: TextStyle(fontSize: 18.sp)), onPressed: () => Get.back()),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ColorConst.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Text(TextConst.yes, style: TextStyle(fontSize: 18.sp)),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
