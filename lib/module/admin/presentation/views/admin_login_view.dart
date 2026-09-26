import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';

class AdminLoginView extends GetView<AdminController> {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
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
                    SizedBox(height: 30.h),
                    Text(
                      TextConst.sellerTitle,
                      style: GoogleFonts.poppins(
                        color: ColorConst.black,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Login Card
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: ColorConst.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          _buildInputLabel(TextConst.username),
                          _buildTextField(
                            controller.usernameController,
                            TextConst.username,
                            TextConst.enterUsername,
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 20.h),
                          _buildInputLabel(TextConst.password),
                          Obx(() => _buildPasswordField(
                            controller.passwordController,
                            TextConst.password,
                            TextConst.enterPasswordAdmin,
                            obscure: controller.obscurePassword.value,
                            icon: Icons.lock_outline,
                            onToggleVisibility: () => controller.togglePasswordVisibility(),
                          )),
                          SizedBox(height: 30.h),
                          Obx(() => GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                controller.loginAdmin();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF5722),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: controller.isLoading.value 
                                  ? SizedBox(
                                      height: 22.r,
                                      width: 22.r,
                                      child: const CircularProgressIndicator(
                                        color: ColorConst.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      TextConst.login,
                                      style: GoogleFonts.poppins(
                                        color: ColorConst.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              ),
                            ),
                          )),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorConst.black,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    String errorMsg, {
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 15.sp, color: ColorConst.black),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        prefixIcon: Icon(icon, color: const Color(0xFFFF5722), size: 22.r),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    String errorMsg, {
    required bool obscure,
    required IconData icon,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(fontSize: 15.sp, color: ColorConst.black),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        prefixIcon: Icon(icon, color: const Color(0xFFFF5722), size: 22.r),
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey[500],
            size: 22.r,
          ),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
