import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';

class AdminLoginView extends GetView<AdminController> {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: ColorConst.adminLoginBg,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, size: 24.r), onPressed: () => Get.back()),
        backgroundColor: ColorConst.transparent, elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.sh / 2),
            padding: EdgeInsets.only(top: 45.h, left: 20.w, right: 20.w),
            height: 1.sh, width: 1.sw,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ColorConst.blue, ColorConst.orange, ColorConst.red]),
              borderRadius: BorderRadius.vertical(top: Radius.elliptical(1.sw, 110.h)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 40.h),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Center(child: Text(TextConst.sellerTitle, style: TextStyle(color: ColorConst.black, fontSize: 28.sp, fontWeight: FontWeight.bold))),
                  SizedBox(height: 30.h),
                  Material(
                    elevation: 3, borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      height: 1.sh / 2.2,
                      decoration: BoxDecoration(color: ColorConst.white, borderRadius: BorderRadius.circular(20.r)),
                      child: Column(
                        children: [
                          SizedBox(height: 50.h),
                          _buildTextField(controller.usernameController, TextConst.username, TextConst.enterUsername),
                          SizedBox(height: 30.h),
                          _buildTextField(controller.passwordController, TextConst.password, TextConst.enterPasswordAdmin, obscure: true),
                          SizedBox(height: 50.h),
                          Obx(() => GestureDetector(
                            onTap: () { if (formKey.currentState!.validate()) controller.loginAdmin(); },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ColorConst.orange, ColorConst.red]),
                                borderRadius: BorderRadius.circular(10.r)
                              ),
                              child: Center(
                                child: controller.isLoading.value 
                                  ? SizedBox(height: 25.r, width: 25.r, child: const CircularProgressIndicator(color: ColorConst.white, strokeWidth: 2))
                                  : Text(TextConst.login, style: TextStyle(color: ColorConst.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, String errorMsg, {bool obscure = false}) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 5.h, bottom: 5.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(border: Border.all(color: ColorConst.adminBorder), borderRadius: BorderRadius.circular(10.r)),
      child: Center(
        child: TextFormField(
          controller: controller, obscureText: obscure,
          style: TextStyle(fontSize: 16.sp),
          validator: (value) => value == null || value.isEmpty ? errorMsg : null,
          decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: TextStyle(color: ColorConst.adminBorder, fontSize: 18.sp)),
        ),
      ),
    );
  }
}
