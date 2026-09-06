import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';
import '../controllers/order_tracking_controller.dart';

class OrderTrackingView extends GetView<OrderTrackingController> {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String orderId = (args != null && args is Map && args['orderId'] != null)
        ? args['orderId'].toString()
        : '';
    
    // Automatically loads passed orderId or fetches latest order
    controller.loadOrder(orderId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TextConst.orderTracking),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
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
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.grey600),
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
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.grey600),
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
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order #${currentOrderId.length >= 6 ? currentOrderId.substring(currentOrderId.length - 6) : currentOrderId}', style: AppWidget.boldTextFieldStyle()),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(20.r)),
                                child: Text(status, style: const TextStyle(color: ColorConst.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text('Placed on ${DateFormat('MMM dd, yyyy - hh:mm a').format(orderDate)}', style: TextStyle(color: ColorConst.grey600, fontSize: 14.sp)),
                          SizedBox(height: 16.h),
                          _buildStatusIndicator(status),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(TextConst.yourOrder, style: AppWidget.boldTextFieldStyle()),
                  SizedBox(height: 12.h),
                  ...items.map((item) => _buildOrderItem(item)).toList(),
                  SizedBox(height: 20.h),
                  Text(TextConst.deliveryInfo, style: AppWidget.boldTextFieldStyle()),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: ColorConst.red400, size: 20.r),
                              SizedBox(width: 10.w),
                              Text(TextConst.deliveryAddress, style: AppWidget.semiBoldFieldStyle()),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(orderData['deliveryAddress'] ?? TextConst.notSpecified, style: TextStyle(color: ColorConst.grey600, fontSize: 14.sp)),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Icon(Icons.access_time, color: ColorConst.blue400, size: 20.r),
                              SizedBox(width: 10.w),
                              Text(TextConst.estimatedDelivery, style: AppWidget.semiBoldFieldStyle()),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(_getEstimatedDeliveryTime(status), style: TextStyle(color: ColorConst.grey600, fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(TextConst.paymentSummary, style: AppWidget.boldTextFieldStyle()),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          _buildPaymentRow(TextConst.subtotal, '₹${(totalAmount * 0.9).toStringAsFixed(2)}'),
                          _buildPaymentRow(TextConst.deliveryFee, '₹${(totalAmount * 0.1).toStringAsFixed(2)}'),
                          const Divider(),
                          _buildPaymentRow(TextConst.totalAmount, '₹${totalAmount.toStringAsFixed(2)}', isTotal: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    if (status == TextConst.orderPlacedStatus) return ColorConst.orange;
    if (status == TextConst.orderPreparingStatus) return ColorConst.blue;
    if (status == TextConst.orderOnTheWayStatus) return ColorConst.purple;
    if (status == TextConst.orderDeliveredStatus) return ColorConst.green;
    return ColorConst.grey;
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
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? ColorConst.black : ColorConst.grey600)),
          Text(value, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? ColorConst.black : ColorConst.grey600)),
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
        LinearProgressIndicator(
          value: (currentIndex + 1) / statuses.length,
          backgroundColor: ColorConst.grey200,
          valueColor: const AlwaysStoppedAnimation<Color>(ColorConst.green),
          minHeight: 6.h,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: statuses.map((s) {
            bool isCompleted = statuses.indexOf(s) <= currentIndex;
            return Column(
              children: [
                Container(
                  width: 24.r, height: 24.r,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isCompleted ? ColorConst.green : ColorConst.greyShade300),
                  child: Center(child: isCompleted ? Icon(Icons.check, size: 14.r, color: ColorConst.white) : null),
                ),
                SizedBox(height: 4.h),
                Text(s, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isCompleted ? ColorConst.black : ColorConst.grey)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                item['image'], width: 70.w, height: 70.h, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(width: 70.w, height: 70.h, color: ColorConst.grey200, child: Icon(Icons.fastfood, color: ColorConst.grey, size: 30.r)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: AppWidget.semiBoldFieldStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text('Qty: ${item['quantity']}', style: TextStyle(color: ColorConst.grey600, fontSize: 12.sp)),
                ],
              ),
            ),
            Text('₹${double.parse(item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')).toStringAsFixed(2)}', style: AppWidget.semiBoldFieldStyle()),
          ],
        ),
      ),
    );
  }
}
