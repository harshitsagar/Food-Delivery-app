import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

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
                SizedBox(height: 0.51.sh),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 12.h, left: 25.w, right: 25.w, bottom: 35.h),
                  decoration: BoxDecoration(
                    color: ColorConst.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                    boxShadow: [
                      BoxShadow(color: ColorConst.black12, blurRadius: 20.r, offset: Offset(0, -5.h)),
                    ],
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(color: ColorConst.orangeAccent, borderRadius: BorderRadius.circular(10.r)),
                        ),
                        SizedBox(height: 25.h),
                        RichText(
                          text: TextSpan(
                            text: TextConst.welcome,
                            style: TextStyle(
                              color: ColorConst.darkGrey,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: TextConst.back, style: TextStyle(color: ColorConst.orangeAccent)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          TextConst.loginSubtitle,
                          style: TextStyle(color: ColorConst.black54, fontSize: 14.sp, fontFamily: 'Poppins'),
                        ),
                        SizedBox(height: 30.h),
                        
                        TextFormField(
                          controller: controller.useremailController,
                          focusNode: controller.emailFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterEmail;
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(controller.passwordFocusNode);
                          },
                          decoration: InputDecoration(
                            hintText: TextConst.emailHint,
                            hintStyle: TextStyle(color: ColorConst.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.email_outlined, color: ColorConst.orangeAccent, size: 22.r),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.greyShade200)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.greyShade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.orangeAccent)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        
                        Obx(() => TextFormField(
                          controller: controller.userpasswordController,
                          focusNode: controller.passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterPassword;
                            return null;
                          },
                          obscureText: controller.obscureText.value,
                          decoration: InputDecoration(
                            hintText: TextConst.passwordHint,
                            hintStyle: TextStyle(color: ColorConst.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.lock_outline, color: ColorConst.orangeAccent, size: 22.r),
                            suffixIcon: GestureDetector(
                              onTap: () => controller.togglePasswordVisibility(),
                              child: Icon(controller.obscureText.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: ColorConst.grey, size: 22.r),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.greyShade200)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.greyShade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: ColorConst.orangeAccent)),
                          ),
                        )),
                        
                        SizedBox(height: 12.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoute.forgotPassword),
                            child: RichText(
                              text: TextSpan(
                                text: TextConst.forgot,
                                style: TextStyle(color: ColorConst.black54, fontSize: 13.sp),
                                children: [
                                  TextSpan(text: TextConst.passwordQuestion, style: TextStyle(color: ColorConst.orangeAccent, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        
                        Obx(() => GestureDetector(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              controller.userLogin(context);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [ColorConst.orange, ColorConst.deepOrange]),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [BoxShadow(color: ColorConst.orange.withOpacity(0.3), spreadRadius: 1, blurRadius: 8.r, offset: Offset(0, 4.h))],
                            ),
                            child: Center(
                              child: controller.loading.value 
                                ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: ColorConst.white, strokeWidth: 2))
                                : Text(TextConst.login, style: TextStyle(color: ColorConst.white, fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                            ),
                          ),
                        )),
                        
                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            Expanded(child: Divider(color: ColorConst.greyShade300)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: Text(TextConst.orContinueWith, style: TextStyle(color: ColorConst.grey, fontSize: 12.sp))),
                            Expanded(child: Divider(color: ColorConst.greyShade300)),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        
                        GestureDetector(
                          onTap: () => controller.loginWithGoogle(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: ColorConst.white,
                              border: Border.all(color: ColorConst.lightGrey),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [BoxShadow(color: ColorConst.black.withOpacity(0.05), blurRadius: 10.r, offset: Offset(0, 5.h))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(ImageConst.googleLogo, height: 22.r),
                                SizedBox(width: 10.w),
                                Text(TextConst.continueWithGoogle, style: TextStyle(color: ColorConst.black87, fontSize: 15.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(TextConst.dontHaveAccount, style: TextStyle(color: ColorConst.black87, fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoute.signup),
                              child: Text(TextConst.signUp, style: TextStyle(color: ColorConst.orangeAccent, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  color: ColorConst.white,
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
                            Icon(Icons.fastfood_outlined, color: ColorConst.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.local_pizza_outlined, color: ColorConst.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.lunch_dining_outlined, color: ColorConst.orangeAccent.withOpacity(0.3), size: 24.r),
                            Icon(Icons.icecream_outlined, color: ColorConst.orangeAccent.withOpacity(0.3), size: 24.r),
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
    var paint = Paint()..color = ColorConst.orangeAccent.withOpacity(0.15)..style = PaintingStyle.fill;
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
