import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String orderId = (args != null && args is Map && args['orderId'] != null)
        ? args['orderId'].toString()
        : '';
    
    controller.loadOrder(orderId);

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
            children: [
              // Custom Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
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
                    Expanded(
                      child: Center(
                        child: Text(
                          TextConst.orderTracking,
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 36.w),
                  ],
                ),
              ),

              // Content Body
              Expanded(
                child: Obx(() {
                  if (controller.isNotFound.value) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 60.r, color: ColorConst.grey),
                            SizedBox(height: 16.h),
                            Text(
                              "No active orders found",
                              style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.grey600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.orderStream.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return StreamBuilder<DocumentSnapshot>(
                    stream: controller.orderStream.value,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('${TextConst.error}: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.hourglass_empty, size: 60.r, color: ColorConst.grey),
                                SizedBox(height: 16.h),
                                Text(
                                  "Loading order details...",
                                  style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.grey600),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final orderData = snapshot.data!.data() as Map<String, dynamic>;
                      final currentOrderId = orderData['orderId']?.toString() ?? orderId;
                      final status = orderData['status'] as String;
                      final totalAmount = (orderData['totalAmount'] as num).toDouble();
                      final items = orderData['items'] as List<dynamic>;
                      final orderDate = (orderData['orderDate'] as Timestamp).toDate();

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.r),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #${currentOrderId.length >= 6 ? currentOrderId.substring(currentOrderId.length - 6) : currentOrderId}',
                                        style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          status,
                                          style: GoogleFonts.poppins(color: ColorConst.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Placed on ${DateFormat('MMM dd, yyyy - hh:mm a').format(orderDate)}',
                                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13.sp),
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildStatusIndicator(status),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              TextConst.yourOrder,
                              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                            ),
                            SizedBox(height: 12.h),
                            ...items.map((item) => _buildOrderItem(item)).toList(),
                            SizedBox(height: 20.h),
                            Text(
                              TextConst.deliveryInfo,
                              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: const Color(0xFFFF5722), size: 22.r),
                                      SizedBox(width: 10.w),
                                      Text(
                                        TextConst.deliveryAddress,
                                        style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    orderData['deliveryAddress'] ?? TextConst.notSpecified,
                                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13.sp),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_filled, color: const Color(0xFFFF5722), size: 22.r),
                                      SizedBox(width: 10.w),
                                      Text(
                                        TextConst.estimatedDelivery,
                                        style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    _getEstimatedDeliveryTime(status),
                                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              TextConst.paymentSummary,
                              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
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
                              child: Column(
                                children: [
                                  _buildPaymentRow(TextConst.subtotal, '₹${(totalAmount * 0.9).toStringAsFixed(2)}'),
                                  _buildPaymentRow(TextConst.deliveryFee, '₹${(totalAmount * 0.1).toStringAsFixed(2)}'),
                                  const Divider(color: Colors.black12),
                                  _buildPaymentRow(TextConst.totalAmount, '₹${totalAmount.toStringAsFixed(2)}', isTotal: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == TextConst.orderPlacedStatus) return const Color(0xFFFF5722);
    if (status == TextConst.orderPreparingStatus) return Colors.blue;
    if (status == TextConst.orderOnTheWayStatus) return Colors.purple;
    if (status == TextConst.orderDeliveredStatus) return Colors.green;
    return Colors.grey;
  }

  String _getEstimatedDeliveryTime(String status) {
    final now = DateTime.now();
    if (status == TextConst.orderPlacedStatus) return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 45)))}';
    if (status == TextConst.orderPreparingStatus) return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 30)))}';
    if (status == TextConst.orderOnTheWayStatus) return 'Arriving soon (${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 15)))})';
    if (status == TextConst.orderDeliveredStatus) return 'Delivered at ${DateFormat('hh:mm a').format(now)}';
    return 'Calculating...';
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? ColorConst.black : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              color: isTotal ? const Color(0xFFFF5722) : ColorConst.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    List<String> statuses = [
      TextConst.orderPlacedStatus,
      TextConst.orderPreparingStatus,
      TextConst.orderOnTheWayStatus,
      TextConst.orderDeliveredStatus
    ];
    int currentIndex = statuses.indexOf(status);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: (currentIndex + 1) / statuses.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF5722)),
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: statuses.map((s) {
            bool isCompleted = statuses.indexOf(s) <= currentIndex;
            return Column(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? const Color(0xFFFF5722) : Colors.grey[300],
                  ),
                  child: Center(
                    child: isCompleted ? Icon(Icons.check, size: 14.r, color: ColorConst.white) : null,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  s,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? ColorConst.black : Colors.grey[500],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              item['image'],
              width: 70.w,
              height: 70.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70.w,
                height: 70.h,
                color: Colors.grey[200],
                child: const Icon(Icons.fastfood, color: Colors.grey, size: 30),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorConst.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: ${item['quantity']}',
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Text(
            '₹${double.parse(item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')).toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF5722),
            ),
          ),
        ],
      ),
    );
  }
}
