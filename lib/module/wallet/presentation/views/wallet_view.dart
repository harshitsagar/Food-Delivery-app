import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/wallet/presentation/controllers/wallet_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Container(
        margin: EdgeInsets.only(top: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Center(
                  child: Text(
                    TextConst.wallet,
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              width: 1.sw,
              decoration: const BoxDecoration(color: ColorConst.walletBg),
              child: Row(
                children: [
                  Image.asset(ImageConst.wallet, height: 60.r, width: 60.r, fit: BoxFit.cover),
                  SizedBox(width: 40.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(TextConst.yourWallet, style: AppWidget.LightTextFieldStyle()),
                      SizedBox(height: 5.h),
                      Obx(() => Text(
                        "₹${double.parse(controller.walletBalance.value).toStringAsFixed(2)}",
                        style: AppWidget.boldTextFieldStyle(),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                TextConst.addMoneyLabel,
                style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton("100"),
                _buildAmountButton("500"),
                _buildAmountButton("1000"),
                _buildAmountButton("2000"),
              ],
            ),
            SizedBox(height: 50.h),
            GestureDetector(
              onTap: () => _openEditDialog(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50.w),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                width: 1.sw,
                decoration: BoxDecoration(color: ColorConst.tealWallet, borderRadius: BorderRadius.circular(8.r)),
                child: Center(
                  child: Text(
                    TextConst.addMoney,
                    style: TextStyle(color: ColorConst.white, fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildAmountButton(String amount) {
    return GestureDetector(
      onTap: () => _showPaymentBottomSheet(amount),
      child: Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(border: Border.all(color: ColorConst.amountBorder), borderRadius: BorderRadius.circular(5.r)),
        child: Text("₹$amount", style: AppWidget.semiBoldFieldStyle()),
      ),
    );
  }

  void _showPaymentBottomSheet(String amount) {
    controller.isProcessingPayment.value = false;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        height: 0.6.sh,
        decoration: BoxDecoration(color: ColorConst.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(TextConst.addMoneyToWallet, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.close, size: 24.r), onPressed: () => Get.back()),
              ],
            ),
            SizedBox(height: 20.h),
            Text("${TextConst.amountPrefix}$amount", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 30.h),
            Obx(() => controller.isProcessingPayment.value ? const SizedBox() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(TextConst.testPaymentMethod, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 15.h),
                _buildPaymentMethod(icon: Icons.credit_card, title: TextConst.testCard, subtitle: TextConst.visaTest),
              ],
            )),
            const Spacer(),
            Obx(() => controller.isProcessingPayment.value 
              ? Center(child: Column(children: [const CircularProgressIndicator(), SizedBox(height: 20.h), const Text(TextConst.processingPayment)]))
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: ColorConst.tealWallet, padding: EdgeInsets.symmetric(vertical: 15.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                  onPressed: () async {
                    controller.isProcessingPayment.value = true;
                    await Future.delayed(const Duration(seconds: 2));
                    Get.back();
                    await controller.addMoneyToWallet(amount);
                  },
                  child: Text("${TextConst.payPrefix}$amount", style: TextStyle(color: ColorConst.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPaymentMethod({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(border: Border.all(color: ColorConst.greyShade300), borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Icon(icon, size: 30.r),
          SizedBox(width: 15.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 14.sp, color: ColorConst.grey)),
          ]),
        ],
      ),
    );
  }

  void _openEditDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GestureDetector(onTap: () => Get.back(), child: Icon(Icons.cancel, size: 24.r)),
                SizedBox(width: 40.w),
                Center(child: Text(TextConst.addMoney, style: TextStyle(color: ColorConst.tealWallet, fontWeight: FontWeight.bold))),
              ]),
              SizedBox(height: 20.h),
              Text(TextConst.amount, style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(border: Border.all(color: ColorConst.black38, width: 1.w), borderRadius: BorderRadius.circular(10.r)),
                child: TextField(
                  controller: controller.amountController, 
                  keyboardType: TextInputType.number, 
                  style: TextStyle(fontSize: 16.sp),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: TextConst.enterAmount),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (controller.amountController.text.isNotEmpty) {
                      String amount = controller.amountController.text;
                      Get.back();
                      _showPaymentBottomSheet(amount);
                    } else {
                      Get.snackbar(TextConst.error, TextConst.enterAmountError);
                    }
                  },
                  child: Container(
                    width: 100.w, padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(color: ColorConst.tealWallet, borderRadius: BorderRadius.circular(10.r)),
                    child: Center(child: Text(TextConst.pay, style: TextStyle(color: ColorConst.white, fontSize: 16.sp))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
