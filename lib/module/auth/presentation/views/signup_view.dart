import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1.sh,
            child: Image.asset(
              ImageConst.authBg,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 0.46.sh),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 12.h, left: 25.w, right: 25.w, bottom: 35.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20.r, offset: Offset(0, -5.h)),
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10.r)),
                        ),
                        SizedBox(height: 25.h),
                        RichText(
                          text: TextSpan(
                            text: TextConst.signUpPrefix,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: TextConst.signUpSuffix, style: TextStyle(color: Colors.orangeAccent)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          TextConst.signUpSubtitle,
                          style: TextStyle(color: Colors.black54, fontSize: 14.sp, fontFamily: 'Poppins'),
                        ),
                        SizedBox(height: 30.h),
                        
                        TextFormField(
                          controller: controller.nameController,
                          focusNode: controller.nameFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterName;
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(controller.emailFocusNode);
                          },
                          decoration: InputDecoration(
                            hintText: TextConst.nameHint,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.orangeAccent, size: 22.r),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        
                        TextFormField(
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterEmail;
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(controller.passwordFocusNode);
                          },
                          decoration: InputDecoration(
                            hintText: TextConst.email,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.orangeAccent, size: 22.r),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        
                        Obx(() => TextFormField(
                          controller: controller.passwordController,
                          focusNode: controller.passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterPassword;
                            return null;
                          },
                          obscureText: controller.obscureText.value,
                          decoration: InputDecoration(
                            hintText: TextConst.passwordHint,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.orangeAccent, size: 22.r),
                            suffixIcon: GestureDetector(
                              onTap: () => controller.togglePasswordVisibility(),
                              child: Icon(controller.obscureText.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 22.r),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        )),
                        SizedBox(height: 40.h),
                        
                        Obx(() => GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.registration(context);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), spreadRadius: 1, blurRadius: 8.r, offset: Offset(0, 4.h))],
                            ),
                            child: Center(
                              child: controller.loading.value
                                ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(TextConst.signUpButton, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                            ),
                          ),
                        )),
                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: Text(TextConst.orContinueWith, style: TextStyle(color: Colors.grey, fontSize: 12.sp))),
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        
                        GestureDetector(
                          onTap: () => controller.loginWithGoogle(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFF5F5F5)),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.r, offset: Offset(0, 5.h))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(ImageConst.googleLogo, height: 22.r),
                                SizedBox(width: 10.w),
                                Text(TextConst.continueWithGoogle, style: TextStyle(color: Colors.black87, fontSize: 15.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(TextConst.alreadyHaveAccount, style: TextStyle(color: Colors.black87, fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoute.login),
                              child: Text(TextConst.login, style: TextStyle(color: Colors.orangeAccent, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(1.sw, 80.h),
                        painter: BottomWavePainter(),
                      ),
                      Positioned(
                        bottom: 20.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.fastfood_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.local_pizza_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.lunch_dining_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.icecream_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24.r),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.orangeAccent.withOpacity(0.15)..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.1, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
