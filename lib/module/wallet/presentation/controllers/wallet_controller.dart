import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:quick_eats_app/core/constant/app_constants.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/module/cart/presentation/controllers/cart_controller.dart';
import '../../domain/usecases/wallet_usecases.dart';

class WalletController extends GetxController {
  final AddMoneyToWalletUseCase addMoneyToWalletUseCase;

  WalletController(this.addMoneyToWalletUseCase);

  var walletBalance = '0'.obs;
  var userId = '0'.obs;
  var isLoading = false.obs;
  var isProcessingPayment = false.obs;
  final amountController = TextEditingController();

  late Razorpay _razorpay;
  String _pendingAmount = '';

  @override
  void onInit() {
    super.onInit();
    _initRazorpay();
    loadWallet();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> loadWallet() async {
    isLoading.value = true;
    walletBalance.value = await SharedPreferenceHelper.getUserWallet() ?? "0";
    userId.value = await SharedPreferenceHelper.getUserId() ?? "0";
    isLoading.value = false;
  }

  void openRazorpayCheckout(String amount) async {
    try {
      double doubleAmount = double.tryParse(amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      if (doubleAmount <= 0) {
        Get.snackbar(TextConst.error, TextConst.enterAmountError);
        return;
      }

      _pendingAmount = amount;
      String userEmail = await SharedPreferenceHelper.getUserEmail() ?? 'customer@quickeats.com';

      var options = {
        'key': AppConstants.razorpayTestKey,
        'amount': (doubleAmount * 100).toInt(), // Amount in paise
        'name': 'Quick Eats Food Delivery',
        'description': 'Add Money to Wallet',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {
          'contact': '9876543210',
          'email': userEmail,
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      Get.snackbar(TextConst.error, e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_pendingAmount.isNotEmpty) {
      await addMoneyToWallet(_pendingAmount);
      _pendingAmount = '';
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "Payment Cancelled ❌",
      response.message ?? "Payment was not completed",
      backgroundColor: ColorConst.red,
      colorText: ColorConst.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handled internally by payment gateway
  }

  Future<void> addMoneyToWallet(String amount) async {
    try {
      isLoading.value = true;
      String cleanWallet = walletBalance.value.replaceAll(RegExp(r'[^0-9.]'), '');
      double currentBalance = double.parse(cleanWallet);
      String cleanAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
      double amountToAdd = double.parse(cleanAmount);
      double newBalance = currentBalance + amountToAdd;

      await addMoneyToWalletUseCase.execute(userId.value, newBalance.toString());
      await SharedPreferenceHelper.saveUserWallet(newBalance.toString());
      
      walletBalance.value = newBalance.toString();

      // Immediately sync with CartController if registered
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().walletBalance.value = newBalance.toString();
        Get.find<CartController>().refreshWalletBalance();
      }

      Get.snackbar(TextConst.success, "Successfully added ₹$amountToAdd to wallet 🎉", backgroundColor: ColorConst.green, colorText: ColorConst.white);
    } catch (e) {
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: ColorConst.red, colorText: ColorConst.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    _razorpay.clear();
    super.onClose();
  }
}
