import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/module/home/presentation/controllers/home_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 60.h, left: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    "${TextConst.hello}${controller.userName.value},",
                    style: AppWidget.boldTextFieldStyle(),
                  )),
                  GestureDetector(
                    onTap: () {}, // Placeholder for cart
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        color: ColorConst.black,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: ColorConst.white,
                        size: 24.r,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                TextConst.deliciousFood,
                style: AppWidget.HeadlineTextFieldStyle(),
              ),
              Text(
                TextConst.discoverFood,
                style: AppWidget.LightTextFieldStyle(),
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.only(right: 15.w),
                child: showCategoryItems(),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 300.h,
                child: allItems(),
              ),
              SizedBox(height: 30.h),
              allItemsVertically(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showCategoryItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryIcon(TextConst.iceCream, ImageConst.iceCream),
        categoryIcon(TextConst.pizza, ImageConst.pizza),
        categoryIcon(TextConst.salad, ImageConst.salad),
        categoryIcon(TextConst.burger, ImageConst.burger),
      ],
    );
  }

  Widget categoryIcon(String name, String imagePath) {
    return Obx(() {
      bool isSelected = controller.isSelected(name);
      return GestureDetector(
        onTap: () => controller.loadFoodItems(name),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? ColorConst.black : ColorConst.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: Image.asset(
              imagePath,
              height: 40.h,
              width: 40.w,
              fit: BoxFit.cover,
              color: isSelected ? ColorConst.white : ColorConst.black,
            ),
          ),
        ),
      );
    });
  }

  Widget allItems() {
    return Obx(() => StreamBuilder(
      stream: controller.foodItemStream.value,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.foodDetails, arguments: {
                  "image": ds["Image"],
                  "detail": ds["Detail"],
                  "name": ds["Name"],
                  "price": ds["Price"]
                });
              },
              child: SizedBox(
                height: 300.h,
                width: 220.w,
                child: Container(
                  margin: EdgeInsets.all(4.r),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                ds["Image"],
                                height: 150.h,
                                width: 250.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              ds["Name"],
                              style: TextStyle(
                                color: ColorConst.black,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              ds["Detail"],
                              style: AppWidget.LightTextFieldStyle(),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "₹${ds["Price"]}",
                              style: AppWidget.semiBoldFieldStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }

  Widget allItemsVertically(BuildContext context) {
    return Obx(() => StreamBuilder(
      stream: controller.foodItemStream.value,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.foodDetails, arguments: {
                  "image": ds["Image"],
                  "detail": ds["Detail"],
                  "name": ds["Name"],
                  "price": ds["Price"]
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w, bottom: 20.h),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.network(
                              ds["Image"],
                              height: 110.h,
                              width: 150.w,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Column(
                          children: [
                            SizedBox(
                              width: 1.sw / 2,
                              child: Text(
                                ds["Name"],
                                style: AppWidget.semiBoldFieldStyle(),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 1.sw / 2,
                              child: Text(
                                ds["Detail"],
                                style: AppWidget.LightTextFieldStyle(),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 1.sw / 2,
                              child: Text(
                                "₹${ds["Price"]}",
                                style: AppWidget.semiBoldFieldStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
