import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/core/services/notification_helper.dart';
import '../../domain/usecases/cart_usecases.dart';

class CartController extends GetxController {
  final GetCartItemsUseCase getCartItemsUseCase;
  final PlaceOrderUseCase placeOrderUseCase;
  final ClearCartUseCase clearCartUseCase;
  final UpdateWalletUseCase updateWalletUseCase;

  CartController(
    this.getCartItemsUseCase,
    this.placeOrderUseCase,
    this.clearCartUseCase,
    this.updateWalletUseCase,
  );

  var userId = ''.obs;
  var walletBalance = '0'.obs;
  var totalAmount = 0.0.obs;
  var isCheckingOut = false.obs;
  var isLoading = true.obs;
  
  Rx<Stream<QuerySnapshot>?> foodStream = Rx<Stream<QuerySnapshot>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  @override
  void onReady() {
    super.onReady();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      userId.value = await SharedPreferenceHelper.getUserId() ?? '';
      walletBalance.value = await SharedPreferenceHelper.getUserWallet() ?? '0';
      
      if (userId.value.isNotEmpty) {
        foodStream.value = await getCartItemsUseCase.execute(userId.value);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(TextConst.error, TextConst.failedToLoadCart);
    }
  }

  void calculateTotal(QuerySnapshot snapshot) {
    double calculatedTotal = 0;
    for (var doc in snapshot.docs) {
      String totalString = doc["Total"].toString().replaceAll(RegExp(r'[^0-9.]'), '');
      calculatedTotal += double.tryParse(totalString) ?? 0;
    }
    totalAmount.value = calculatedTotal;
  }

  Future<void> removeCartItem(String docId) async {
    if (userId.value.isEmpty || docId.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId.value)
          .collection('Cart')
          .doc(docId)
          .delete();
    } catch (e) {
      print("Error removing item from cart: $e");
    }
  }

  Future<void> updateQuantity(DocumentSnapshot ds, bool isIncrement) async {
    if (userId.value.isEmpty) return;
    try {
      int currentQty = int.tryParse(ds["Quantity"].toString()) ?? 1;
      double currentTotal = double.tryParse(ds["Total"].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      double unitPrice = currentQty > 0 ? currentTotal / currentQty : currentTotal;

      if (isIncrement) {
        int newQty = currentQty + 1;
        double newTotal = unitPrice * newQty;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId.value)
            .collection('Cart')
            .doc(ds.id)
            .update({
              'Quantity': newQty.toString(),
              'Total': newTotal.toStringAsFixed(2),
            });
      } else {
        if (currentQty <= 1) {
          await removeCartItem(ds.id);
        } else {
          int newQty = currentQty - 1;
          double newTotal = unitPrice * newQty;
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId.value)
              .collection('Cart')
              .doc(ds.id)
              .update({
                'Quantity': newQty.toString(),
                'Total': newTotal.toStringAsFixed(2),
              });
        }
      }
    } catch (e) {
      print("Error updating item quantity: $e");
    }
  }

  Future<void> placeOrder() async {
    if (isCheckingOut.value || userId.value.isEmpty) return;

    if (totalAmount.value <= 0) {
      Get.snackbar(
        "Cart is Empty 🛒",
        "Your cart is empty! Please add some items to your cart before placing an order.",
        backgroundColor: ColorConst.orange,
        colorText: ColorConst.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    double currentWallet = double.tryParse(walletBalance.value) ?? 0.0;
    if (currentWallet < totalAmount.value) {
      Get.snackbar(
        "Insufficient Balance",
        "Wallet balance (₹${currentWallet.toStringAsFixed(0)}) is less than total amount (₹${totalAmount.value.toStringAsFixed(0)}). Please add money to your wallet.",
        backgroundColor: ColorConst.red,
        colorText: ColorConst.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    try {
      isCheckingOut.value = true;
      
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      List<Map<String, dynamic>> items = await _getCartItems();

      final orderData = {
        'orderId': orderId,
        'userId': userId.value,
        'items': items,
        'totalAmount': totalAmount.value,
        'status': 'Placed',
        'orderDate': DateTime.now(),
        'deliveryAddress': TextConst.userAddressPlaceholder,
      };

      await placeOrderUseCase.execute(orderData);

      await NotificationHelper.showInAppNotification(
        title: "Order Placed Successfully! 🎉",
        body: "Your order (#${orderId.substring(orderId.length - 6)}) worth ₹${totalAmount.value.toStringAsFixed(0)} has been placed and is being prepared.",
        route: AppRoute.orderTracking,
      );

      double newBalance = currentWallet - totalAmount.value;
      try {
        await updateWalletUseCase.execute(userId.value, newBalance.toString());
      } catch (e) {
        print("Error updating wallet in Firestore: $e");
      }
      await SharedPreferenceHelper.saveUserWallet(newBalance.toString());
      walletBalance.value = newBalance.toString();

      try {
        await clearCartUseCase.execute(userId.value);
        totalAmount.value = 0.0;
      } catch (e) {
        print("Error clearing cart: $e");
      }

      isCheckingOut.value = false;
      Get.toNamed(AppRoute.orderTracking, arguments: {'orderId': orderId});
    } catch (e) {
      isCheckingOut.value = false;
      print("Error placing order: $e");
      Get.snackbar(TextConst.error, "${TextConst.errorPlacingOrder}${e.toString()}", backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  Future<List<Map<String, dynamic>>> _getCartItems() async {
    List<Map<String, dynamic>> items = [];
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId.value)
          .collection('Cart')
          .get();
      for (var doc in querySnapshot.docs) {
        items.add({
          'name': doc['Name']?.toString() ?? 'Unknown',
          'price': doc['Total']?.toString() ?? '0',
          'quantity': doc['Quantity']?.toString() ?? '1',
          'image': doc['Image']?.toString() ?? '',
        });
      }
    } catch (e) {
      print("Error fetching cart items: $e");
    }
    return items;
  }
}
