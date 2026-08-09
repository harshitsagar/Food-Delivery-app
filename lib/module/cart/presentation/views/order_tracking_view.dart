import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final String orderId = Get.arguments['orderId'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final status = orderData['status'] as String;
          final totalAmount = orderData['totalAmount'] as double;
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
                            Text('Order #${orderId.substring(orderId.length - 6)}', style: AppWidget.boldTextFieldStyle()),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(color: _getStatusColor(status), borderRadius: BorderRadius.circular(20.r)),
                              child: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text('Placed on ${DateFormat('MMM dd, yyyy - hh:mm a').format(orderDate)}', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                        SizedBox(height: 16.h),
                        _buildStatusIndicator(status),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Your Order', style: AppWidget.boldTextFieldStyle()),
                SizedBox(height: 12.h),
                ...items.map((item) => _buildOrderItem(item)).toList(),
                SizedBox(height: 20.h),
                Text('Delivery Information', style: AppWidget.boldTextFieldStyle()),
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
                            Icon(Icons.location_on, color: Colors.red[400], size: 20.r),
                            SizedBox(width: 10.w),
                            Text('Delivery Address', style: AppWidget.semiBoldFieldStyle()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(orderData['deliveryAddress'] ?? 'Not specified', style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue[400], size: 20.r),
                            SizedBox(width: 10.w),
                            Text('Estimated Delivery', style: AppWidget.semiBoldFieldStyle()),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(_getEstimatedDeliveryTime(status), style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Payment Summary', style: AppWidget.boldTextFieldStyle()),
                SizedBox(height: 12.h),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        _buildPaymentRow('Subtotal', '₹${(totalAmount * 0.9).toStringAsFixed(2)}'),
                        _buildPaymentRow('Delivery Fee', '₹${(totalAmount * 0.1).toStringAsFixed(2)}'),
                        const Divider(),
                        _buildPaymentRow('Total Amount', '₹${totalAmount.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Placed': return Colors.orange;
      case 'Preparing': return Colors.blue;
      case 'On the way': return Colors.purple;
      case 'Delivered': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _getEstimatedDeliveryTime(String status) {
    final now = DateTime.now();
    switch (status) {
      case 'Placed': return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 45)))}';
      case 'Preparing': return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 30)))}';
      case 'On the way': return 'Arriving soon (${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 15)))})';
      case 'Delivered': return 'Delivered at ${DateFormat('hh:mm a').format(now)}';
      default: return 'Calculating...';
    }
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.black : Colors.grey[600])),
          Text(value, style: TextStyle(fontSize: isTotal ? 16.sp : 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.black : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    List<String> statuses = ['Placed', 'Preparing', 'On the way', 'Delivered'];
    int currentIndex = statuses.indexOf(status);

    return Column(
      children: [
        LinearProgressIndicator(
          value: (currentIndex + 1) / statuses.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isCompleted ? Colors.green : Colors.grey[300]),
                  child: Center(child: isCompleted ? Icon(Icons.check, size: 14.r, color: Colors.white) : null),
                ),
                SizedBox(height: 4.h),
                Text(s, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isCompleted ? Colors.black : Colors.grey)),
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
                errorBuilder: (context, error, stackTrace) => Container(width: 70.w, height: 70.h, color: Colors.grey[200], child: Icon(Icons.fastfood, color: Colors.grey, size: 30.r)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: AppWidget.semiBoldFieldStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text('Qty: ${item['quantity']}', style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
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
