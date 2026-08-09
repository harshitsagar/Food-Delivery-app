import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class WalletController extends GetxController {
  var walletBalance = '0'.obs;
  var userId = '0'.obs;
  var isLoading = false.obs;
  var isProcessingPayment = false.obs;
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadWallet();
  }

  Future<void> loadWallet() async {
    isLoading.value = true;
    walletBalance.value = await SharedPreferenceHelper.getUserWallet() ?? "0";
    userId.value = await SharedPreferenceHelper.getUserId() ?? "0";
    isLoading.value = false;
  }

  Future<void> addMoneyToWallet(String amount) async {
    try {
      isLoading.value = true;
      String cleanWallet = walletBalance.value.replaceAll(RegExp(r'[^0-9.]'), '');
      double currentBalance = double.parse(cleanWallet);
      String cleanAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
      double amountToAdd = double.parse(cleanAmount);
      double newBalance = currentBalance + amountToAdd;

      await SharedPreferenceHelper.saveUserWallet(newBalance.toString());
      await DatabaseMethods().UpdateUserWallet(userId.value, newBalance.toString());
      
      walletBalance.value = newBalance.toString();
      Get.snackbar("Success", "Successfully added ₹$amountToAdd to wallet", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
