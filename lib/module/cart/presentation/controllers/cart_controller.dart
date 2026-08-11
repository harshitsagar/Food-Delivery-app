import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
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

  Future<void> placeOrder() async {
    if (isCheckingOut.value || userId.value.isEmpty) return;

    if (double.parse(walletBalance.value) < totalAmount.value) {
      Get.snackbar(TextConst.error, TextConst.insufficientBalance, backgroundColor: ColorConst.red, colorText: ColorConst.white);
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

      double newBalance = double.parse(walletBalance.value) - totalAmount.value;
      await updateWalletUseCase.execute(userId.value, newBalance.toString());
      await SharedPreferenceHelper.saveUserWallet(newBalance.toString());
      walletBalance.value = newBalance.toString();

      await clearCartUseCase.execute(userId.value);

      isCheckingOut.value = false;
      Get.toNamed(AppRoute.orderTracking, arguments: {'orderId': orderId});
    } catch (e) {
      isCheckingOut.value = false;
      Get.snackbar(TextConst.error, "${TextConst.errorPlacingOrder}${e.toString()}", backgroundColor: ColorConst.red, colorText: ColorConst.white);
    }
  }

  Future<List<Map<String, dynamic>>> _getCartItems() async {
    List<Map<String, dynamic>> items = [];
    if (foodStream.value != null) {
      var snapshot = await foodStream.value!.first;
      for (var doc in snapshot.docs) {
        items.add({
          'name': doc['Name']?.toString() ?? 'Unknown',
          'price': doc['Total']?.toString() ?? '0',
          'quantity': doc['Quantity']?.toString() ?? '1',
          'image': doc['Image']?.toString() ?? '',
        });
      }
    }
    return items;
  }
}
