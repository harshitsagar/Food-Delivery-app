import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/image_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/wallet/presentation/controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

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
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  // Header Title: Wallet
                  Center(
                    child: Text(
                      TextConst.wallet,
                      style: GoogleFonts.poppins(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  const Divider(color: Colors.black12, thickness: 1),
                  SizedBox(height: 20.h),

                  // Your Wallet Card
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0E6), Color(0xFFFFD1B3)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConst.wallet,
                          height: 60.r,
                          width: 60.r,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 24.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TextConst.yourWallet,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Obx(() {
                              double balance = double.tryParse(controller.walletBalance.value) ?? 0.0;
                              return Text(
                                "₹${balance.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConst.black,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // "Add money" Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      TextConst.addMoneyLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorConst.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Quick Amount Chips
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAmountChip("100"),
                        _buildAmountChip("500"),
                        _buildAmountChip("1000"),
                        _buildAmountChip("2000"),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Main "Add Money" Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GestureDetector(
                      onTap: () => _openEditDialog(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5722),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5722).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            TextConst.addMoney,
                            style: GoogleFonts.poppins(
                              color: ColorConst.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 95.h), // Bottom spacing for curved bottom navigation bar
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount) {
    return GestureDetector(
      onTap: () => _showPaymentBottomSheet(amount),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.black12, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "₹$amount",
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: ColorConst.black,
          ),
        ),
      ),
    );
  }

  void _showPaymentBottomSheet(String amount) {
    controller.isProcessingPayment.value = false;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        height: 0.6.sh,
        decoration: BoxDecoration(
          color: ColorConst.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TextConst.addMoneyToWallet,
                  style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.r, color: ColorConst.black),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "${TextConst.amountPrefix}$amount",
              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF5722)),
            ),
            SizedBox(height: 30.h),
            Obx(() => controller.isProcessingPayment.value
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TextConst.testPaymentMethod,
                        style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: ColorConst.black),
                      ),
                      SizedBox(height: 15.h),
                      _buildPaymentMethod(
                        icon: Icons.credit_card,
                        title: TextConst.testCard,
                        subtitle: TextConst.visaTest,
                      ),
                    ],
                  )),
            const Spacer(),
            Obx(() => controller.isProcessingPayment.value
                ? Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: Color(0xFFFF5722)),
                        SizedBox(height: 20.h),
                        Text(
                          TextConst.processingPayment,
                          style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5722),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      ),
                      onPressed: () async {
                        controller.isProcessingPayment.value = true;
                        await Future.delayed(const Duration(seconds: 2));
                        Get.back();
                        await controller.addMoneyToWallet(amount);
                      },
                      child: Text(
                        "${TextConst.payPrefix}$amount",
                        style: GoogleFonts.poppins(color: ColorConst.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
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
      decoration: BoxDecoration(
        border: Border.all(color: ColorConst.greyShade300),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30.r, color: const Color(0xFFFF5722)),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold, color: ColorConst.black)),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 13.sp, color: ColorConst.grey)),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextConst.addMoney,
                    style: GoogleFonts.poppins(color: const Color(0xFFFF5722), fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.cancel_outlined, size: 24.r, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                TextConst.amount,
                style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: ColorConst.black),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConst.black38, width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(fontSize: 16.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: TextConst.enterAmount,
                    hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
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
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        TextConst.pay,
                        style: GoogleFonts.poppins(color: ColorConst.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
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
