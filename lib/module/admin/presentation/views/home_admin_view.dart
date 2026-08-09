import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class HomeAdminView extends StatelessWidget {
  const HomeAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, size: 24.r), onPressed: () => Get.offAllNamed(AppRoute.home)),
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text("Admin Home", style: AppWidget.HeadlineTextFieldStyle()),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.addFood),
              child: Material(
                elevation: 10, borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(6.r), child: Image.asset("images/food.jpg", height: 100.h, width: 100.w, fit: BoxFit.cover)),
                      SizedBox(width: 30.w),
                      Text("Add Food Items", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
