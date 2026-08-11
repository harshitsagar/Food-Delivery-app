import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});

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
                SizedBox(height: 0.54.sh),
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
                            text: TextConst.forgot,
                            style: TextStyle(
                              color: const Color(0xFF333333),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: TextConst.passwordQuestion, style: TextStyle(color: Colors.orangeAccent)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          TextConst.forgotSubtitle,
                          style: TextStyle(color: Colors.black54, fontSize: 14.sp, fontFamily: 'Poppins'),
                        ),
                        SizedBox(height: 30.h),
                        
                        TextFormField(
                          controller: controller.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return TextConst.enterEmail;
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: TextConst.emailHint,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.orangeAccent, size: 22.r),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        Obx(() => GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              controller.resetPassword();
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
                                : Text(TextConst.sendRecoveryEmail, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                            ),
                          ),
                        )),
                        
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(TextConst.dontHaveAccount, style: TextStyle(color: Colors.black87, fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoute.signup),
                              child: Text(TextConst.signUp, style: TextStyle(color: Colors.orangeAccent, fontSize: 14.sp, fontWeight: FontWeight.bold)),
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
          // Back Button
          Positioned(
            top: 45.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8.r)],
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 20.r, color: Colors.black87),
              ),
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
