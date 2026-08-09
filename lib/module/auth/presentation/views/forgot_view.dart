import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/auth/presentation/controllers/forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 70.h),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Password Recovery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.w),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: TextFormField(
                        controller: controller.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter the Email\n";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your email here",
                          hintStyle: TextStyle(fontSize: 18.sp, color: Colors.white,),
                          prefixIcon: Icon(Icons.person, color: Colors.white70, size: 30.r,),
                          border: InputBorder.none,
                        ),
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
                        width: 140.w,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: controller.loading.value 
                            ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            : Text(
                                "Send email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                        ),
                      ),
                    )),
                    SizedBox(height: 50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoute.signup),
                          child: Text(
                            "Create",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 184, 166, 6),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
