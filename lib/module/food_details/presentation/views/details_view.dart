import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
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
                SizedBox(height: 16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image.network(
                    data['image'],
                    height: 1.sh / 3.2,
                    width: 1.sw,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 1.sh / 3.2,
                      width: 1.sw,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 50),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorConst.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () => controller.decrement(),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.remove, color: ColorConst.white, size: 20.r),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Obx(() => Text(
                      controller.quantity.value.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.black,
                      ),
                    )),
                    SizedBox(width: 14.w),
                    GestureDetector(
                      onTap: () => controller.increment(),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.add, color: ColorConst.white, size: 20.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  data['detail'],
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      TextConst.deliveryTime,
                      style: GoogleFonts.poppins(
                        color: ColorConst.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Icon(
                      Icons.alarm, 
                      color: const Color(0xFFFF5722),
                      size: 22.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      TextConst.min30,
                      style: GoogleFonts.poppins(
                        color: ColorConst.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TextConst.totalPrice,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Obx(() => Text(
                          "₹${controller.total.value.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF5722),
                          ),
                        )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => controller.addToCart(data['name'], data['image']),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
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
                        child: Row(
                          children: [
                            Text(
                              TextConst.addToCart,
                              style: GoogleFonts.poppins(
                                color: ColorConst.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: ColorConst.white,
                              size: 20.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
