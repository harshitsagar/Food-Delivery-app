import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/module/food_details/presentation/controllers/details_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;
    controller.init(data['price']);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
                size: 24.r,
              ),
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Image.network(
                data['image'],
                height: 1.sh / 3,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'], style: AppWidget.semiBoldFieldStyle()),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                GestureDetector(
                  onTap: () => controller.decrement(),
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.remove, color: Colors.white, size: 20.r),
                  ),
                ),
                SizedBox(width: 20.w),
                Obx(() => Text(controller.quantity.value.toString(), style: AppWidget.semiBoldFieldStyle())),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () => controller.increment(),
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              data['detail'],
              style: AppWidget.LightTextFieldStyle(),
              maxLines: 4,
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(width: 25.w),
                Icon(
                  Icons.alarm, 
                  color: Colors.black54,
                  size: 24.r,
                ),
                SizedBox(width: 5.w),
                Text(
                  "30 min",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldFieldStyle(),
                      ),
                      Obx(() => Text(
                        "₹${controller.total.value.toStringAsFixed(2)}",
                        style: AppWidget.HeadlineTextFieldStyle(),
                      )),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => controller.addToCart(data['name'], data['image']),
                    child: Container(
                      width: 1.sw / 2,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 30.w),
                          Container(
                            padding: EdgeInsets.all(3.r),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 20.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
