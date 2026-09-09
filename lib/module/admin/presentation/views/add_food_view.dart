import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';

class AddFoodView extends GetView<AdminController> {
  const AddFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      TextConst.iceCream,
      TextConst.burger,
      TextConst.salad,
      TextConst.pizza,
    ];

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                          TextConst.addItem,
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
                SizedBox(height: 20.h),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(TextConst.uploadPicture),
                        SizedBox(height: 10.h),
                        Obx(() => GestureDetector(
                          onTap: () => controller.getImage(),
                          child: Center(
                            child: Container(
                              width: 150.r,
                              height: 150.r,
                              decoration: BoxDecoration(
                                color: ColorConst.white,
                                border: Border.all(color: const Color(0xFFFF5722), width: 1.5.w),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: controller.selectedImage.value == null 
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: const Color(0xFFFF5722),
                                        size: 36.r,
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        "Select Image",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(18.r),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            ),
                          ),
                        )),
                        SizedBox(height: 24.h),
                        _buildInputLabel(TextConst.itemName),
                        _buildTextField(controller.foodNameController, TextConst.itemHint),
                        SizedBox(height: 20.h),
                        _buildInputLabel(TextConst.itemPrice),
                        _buildTextField(controller.foodPriceController, TextConst.enterPrice, keyboardType: TextInputType.number),
                        SizedBox(height: 20.h),
                        _buildInputLabel(TextConst.itemDetails),
                        _buildTextField(controller.foodDetailController, TextConst.enterDetails, maxLines: 4),
                        SizedBox(height: 20.h),
                        _buildInputLabel(TextConst.selectCategory),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorConst.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Obx(() => DropdownButton<String>(
                              items: categories.map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.poppins(fontSize: 15.sp, color: ColorConst.black),
                                ),
                              )).toList(),
                              onChanged: (value) => controller.selectedCategory.value = value!,
                              dropdownColor: ColorConst.white,
                              iconSize: 28.r,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF5722)),
                              value: controller.selectedCategory.value,
                            )),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Obx(() => GestureDetector(
                          onTap: () => controller.uploadFoodItem(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5722),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5722).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: controller.isLoading.value 
                                ? SizedBox(
                                    height: 22.r,
                                    width: 22.r,
                                    child: const CircularProgressIndicator(
                                      color: ColorConst.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    TextConst.add,
                                    style: GoogleFonts.poppins(
                                      color: ColorConst.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                        )),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorConst.black,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15.sp, color: ColorConst.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        ),
      ),
    );
  }
}
