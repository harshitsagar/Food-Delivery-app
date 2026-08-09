import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/module/cart/presentation/controllers/cart_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<QuerySnapshot>(
                  stream: controller.foodStream.value,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('Your cart is empty'));

                    // Update total in controller
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.calculateTotal(snapshot.data!);
                    });

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        String totalString = ds["Total"].toString().replaceAll(RegExp(r'[^0-9.]'), '');

                        return Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              child: Row(
                                children: [
                                  Container(
                                    height: 90.h, width: 40.w,
                                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10.r)),
                                    child: Center(child: Text(ds["Quantity"].toString())),
                                  ),
                                  SizedBox(width: 20.w),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60.r),
                                    child: Image.network(
                                      ds["Image"].toString(),
                                      height: 90.h, width: 90.w, fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood, size: 90.r),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(ds["Name"].toString(), style: AppWidget.semiBoldFieldStyle()),
                                        Text("₹$totalString", style: AppWidget.semiBoldFieldStyle()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                    "₹${controller.totalAmount.value.toStringAsFixed(2)}",
                    style: AppWidget.semiBoldFieldStyle(),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() => GestureDetector(
              onTap: () => controller.placeOrder(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                width: 1.sw,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
                margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                child: Center(
                  child: controller.isCheckingOut.value
                      ? SizedBox(height: 25.r, width: 25.r, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text("Place Order", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
