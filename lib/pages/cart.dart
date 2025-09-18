import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  Stream<QuerySnapshot>? foodStream;
  double total = 0;
  double amount2 = 0;
  bool isCheckingOut = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    onTheLoad();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset the cart when returning from order tracking
    _resetCartOnReturn();
  }

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      amount2 = total;
      if (mounted) setState(() {});
    });
  }

  Future<void> _resetCartOnReturn() async {
    // Check if we're returning from order tracking
    final route = ModalRoute.of(context);
    if (route?.isCurrent ?? false) {
      await onTheLoad(); // Reload the cart data
      if (mounted) setState(() {
        total = 0;
        amount2 = 0;
      });
    }
  }

  getTheSharedPref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    if (mounted) setState(() {});
  }

  onTheLoad() async {
    try {
      await getTheSharedPref();
      // Directly assign the stream without await
      foodStream = await DatabaseMethods().getFoodCart(id!);
      if (mounted) setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        isLoading = false;
      });
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> placeOrder() async {
    if (isCheckingOut || id == null || wallet == null) return;

    setState(() => isCheckingOut = true);

    try {
      // 1. Check if user has sufficient balance
      if (double.parse(wallet!) < amount2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Insufficient wallet balance"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 2. Create order document in Firestore
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      List<Map<String, dynamic>> items = await _getCartItems();

      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'userId': id,
        'items': items,
        'totalAmount': amount2,
        'status': 'Placed',
        'orderDate': DateTime.now(),
        'deliveryAddress': 'User Address Here',
      });

      // 3. Update wallet balance
      double newBalance = double.parse(wallet!) - amount2;
      await DatabaseMethods().UpdateUserWallet(id!, newBalance.toString());
      await SharedPreferenceHelper().saveUserWallet(newBalance.toString());

      // 4. Clear the cart
      await DatabaseMethods().clearCart(id!);

      // 5. Navigate to order tracking page (without replacing)
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingPage(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error placing order: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isCheckingOut = false);
    }
  }

  Future<List<Map<String, dynamic>>> _getCartItems() async {
    List<Map<String, dynamic>> items = [];
    try {
      var snapshot = await DatabaseMethods().getFoodCart(id!);
      var docs = (await snapshot.first).docs;

      for (var doc in docs) {
        items.add({
          'name': doc['Name']?.toString() ?? 'Unknown',
          'price': doc['Total']?.toString() ?? '0',
          'quantity': doc['Quantity']?.toString() ?? '1',
          'image': doc['Image']?.toString() ?? '',
        });
      }
    } catch (e) {
      debugPrint('Error getting cart items: $e');
    }
    return items;
  }

  Widget foodCart() {
    return StreamBuilder<QuerySnapshot>(
      stream: foodStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        // Calculate total fresh each time
        double calculatedTotal = 0;
        for (var doc in snapshot.data!.docs) {
          String totalString = doc["Total"].toString().replaceAll(RegExp(r'[^0-9.]'), '');
          calculatedTotal += double.tryParse(totalString) ?? 0;
        }

        // Update total only if different
        if (total != calculatedTotal && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              total = calculatedTotal;
              amount2 = calculatedTotal;
            });
          });
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            String totalString = ds["Total"].toString().replaceAll(RegExp(r'[^0-9.]'), '');

            return Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(ds["Quantity"].toString())),
                      ),
                      const SizedBox(width: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          ds["Image"].toString(),
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.fastfood, size: 90),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["Name"].toString(),
                              style: AppWidget.semiBoldFieldStyle(),
                            ),
                            Text(
                              "₹$totalString",
                              style: AppWidget.semiBoldFieldStyle(),
                            ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 100,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : foodCart(),
            ),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price", style: AppWidget.boldTextFieldStyle()),
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    style: AppWidget.semiBoldFieldStyle(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: placeOrder,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Center(
                  child: isCheckingOut
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Place Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final status = orderData['status'] as String;
          final totalAmount = orderData['totalAmount'] as double;
          final items = orderData['items'] as List<dynamic>;
          final orderDate = (orderData['orderDate'] as Timestamp).toDate();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${orderId.substring(orderId.length - 6)}',
                              style: AppWidget.boldTextFieldStyle(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Placed on ${DateFormat('MMM dd, yyyy - hh:mm a').format(orderDate)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        _buildStatusIndicator(status),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Order Items
                Text(
                  'Your Order',
                  style: AppWidget.boldTextFieldStyle(),
                ),
                const SizedBox(height: 12),
                ...items.map((item) => _buildOrderItem(item)).toList(),

                // Delivery Information
                const SizedBox(height: 20),
                Text(
                  'Delivery Information',
                  style: AppWidget.boldTextFieldStyle(),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red[400]),
                            const SizedBox(width: 10),
                            Text(
                              'Delivery Address',
                              style: AppWidget.semiBoldFieldStyle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          orderData['deliveryAddress'] ?? 'Not specified',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue[400]),
                            const SizedBox(width: 10),
                            Text(
                              'Estimated Delivery',
                              style: AppWidget.semiBoldFieldStyle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getEstimatedDeliveryTime(status),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),

                // Payment Summary
                const SizedBox(height: 20),
                Text(
                  'Payment Summary',
                  style: AppWidget.boldTextFieldStyle(),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildPaymentRow('Subtotal', '₹${(totalAmount * 0.9).toStringAsFixed(2)}'),
                        _buildPaymentRow('Delivery Fee', '₹${(totalAmount * 0.1).toStringAsFixed(2)}'),
                        const Divider(),
                        _buildPaymentRow(
                          'Total Amount',
                          '₹${totalAmount.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
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
      case 'Placed':
        return Colors.orange;
      case 'Preparing':
        return Colors.blue;
      case 'On the way':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getEstimatedDeliveryTime(String status) {
    final now = DateTime.now();
    switch (status) {
      case 'Placed':
        return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 45)))}';
        case 'Preparing':
        return 'Estimated by ${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 30)))}';
        case 'On the way':
        return 'Arriving soon (${DateFormat('hh:mm a').format(now.add(const Duration(minutes: 15)))})';
        case 'Delivered':
        return 'Delivered at ${DateFormat('hh:mm a').format(now)}';
      default:
        return 'Calculating...';
    }
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          minHeight: 6,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: statuses.map((s) {
            bool isCompleted = statuses.indexOf(s) <= currentIndex;
            return Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.green : Colors.grey[300],
                    border: Border.all(
                      color: isCompleted ? Colors.green : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.black : Colors.grey,
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: AppWidget.semiBoldFieldStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item['quantity']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              '₹${double.parse(item['price'].toString().replaceAll(RegExp(r'[^0-9.]'), '')).toStringAsFixed(2)}',
              style: AppWidget.semiBoldFieldStyle(),
            ),
          ],
        ),
      ),
    );
  }
}


/*import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  String? id , wallet ;
  Stream? foodStream ;
  double? total = 0 , amount2 = 0 ;

  void startTimer() {

    Timer(Duration(seconds: 1), () {

      amount2 = total ;

      setState(() {

      });

    });

  }

  getTheSharedPref() async {

    id = await SharedPreferenceHelper().getUserId() ;
    wallet = await SharedPreferenceHelper().getUserWallet() ;

    setState(() {

    });

  }

  onTheLoad() async {

    await getTheSharedPref() ;
    foodStream = await DatabaseMethods().getFoodCart(id!) ;

    setState(() {

    });

  }

  @override
  void initState() {
    onTheLoad() ;
    startTimer() ;
    super.initState();
  }


  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];

              // Remove all non-numeric characters (e.g., $, ₹, commas) before parsing
              String totalString = ds["Total"].replaceAll(RegExp(r'[^0-9.]'), '');
              total = (total! + double.parse(totalString));

              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 90,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Name"],
                                style: AppWidget.semiBoldFieldStyle(),
                              ),
                              Text(
                                "₹$totalString", // Display the cleaned total with ₹ symbol
                                style: AppWidget.semiBoldFieldStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
            : Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Material(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    "Food Cart",
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),

            Expanded(
              flex: 100,
                child: foodCart()
            ),

            Spacer(),

            Divider(),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("Total Price", style: AppWidget.boldTextFieldStyle(),),

                  Text("\₹" + total.toString(), style: AppWidget.semiBoldFieldStyle(),),

                ],
              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(

              onTap: () async {

                double amount = double.parse(wallet!) - amount2! ;

                await DatabaseMethods().UpdateUserWallet(id!, amount.toString()) ;
                await SharedPreferenceHelper().saveUserWallet(amount.toString()) ;

              },

              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Center(child: Text("CheckOut", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),

              ),
            ),



          ],

        ),

      ),


    );
  }
}

 */
