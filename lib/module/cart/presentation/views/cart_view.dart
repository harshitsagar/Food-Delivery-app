import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/cart/presentation/controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // Header Title: Food Cart
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Food ",
                    style: GoogleFonts.poppins(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorConst.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Cart",
                        style: GoogleFonts.poppins(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF5722),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Cart Items Stream List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: controller.foodStream.value,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${TextConst.error}: ${snapshot.error}',
                            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.red),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.totalAmount.value = 0.0;
                        });
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 70.r,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                TextConst.cartEmpty,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Update total in controller
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.calculateTotal(snapshot.data!);
                      });

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: snapshot.data!.docs.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          final data = ds.data() as Map<String, dynamic>? ?? {};
                          dynamic rawQty = data['Quantity'] ?? data['quantity'] ?? '1';
                          dynamic rawTotal = data['Total'] ?? data['total'] ?? '0';
                          String totalString = rawTotal.toString().replaceAll(RegExp(r'[^0-9.]'), '');
                          double itemTotal = double.tryParse(totalString) ?? 0.0;

                          return Container(
                            margin: EdgeInsets.only(bottom: 14.h),
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: ColorConst.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Quantity selector (+ / qty / -)
                                Container(
                                  width: 44.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFFF5722),
                                      width: 1.2.w,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => controller.updateQuantity(ds, true),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                          child: Text(
                                            "+",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF5722),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1.h,
                                        color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 6.h),
                                        child: Text(
                                          rawQty.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConst.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1.h,
                                        color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => controller.updateQuantity(ds, false),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                          child: Text(
                                            "-",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF5722),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Item Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Image.network(
                                    (data['Image'] ?? data['image'] ?? '').toString(),
                                    height: 85.h,
                                    width: 85.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 85.h,
                                      width: 85.w,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.fastfood, size: 30),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),

                                // Title and Total Price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (data['Name'] ?? data['name'] ?? '').toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConst.black,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "₹${itemTotal.toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF5722),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Delete Trash Button
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => controller.removeCartItem(ds.id),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      color: const Color(0xFFFF5722),
                                      size: 24.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),

              // Bottom Section: Total Price & Place Order Button
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 10.h,
                  bottom: 95.h, // Bottom padding prevents overlap with curved bottom navigation bar
                ),
                child: Column(
                  children: [
                    const Divider(color: Colors.black12, thickness: 1),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextConst.totalPrice,
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.black,
                          ),
                        ),
                        Obx(() => Text(
                          "₹${controller.totalAmount.value.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF5722),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Obx(() {
                      bool isCartEmpty = controller.totalAmount.value <= 0;
                      return GestureDetector(
                        onTap: () => controller.placeOrder(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: isCartEmpty ? Colors.grey[400] : const Color(0xFFFF5722),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: isCartEmpty
                                ? []
                                : [
                                    BoxShadow(
                                      color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: controller.isCheckingOut.value
                                ? SizedBox(
                                    height: 24.r,
                                    width: 24.r,
                                    child: const CircularProgressIndicator(
                                      color: ColorConst.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isCartEmpty ? "Your Cart is Empty" : TextConst.placeOrder,
                                        style: GoogleFonts.poppins(
                                          color: ColorConst.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (!isCartEmpty) ...[
                                        SizedBox(width: 8.w),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: ColorConst.white,
                                          size: 20.r,
                                        ),
                                      ],
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
