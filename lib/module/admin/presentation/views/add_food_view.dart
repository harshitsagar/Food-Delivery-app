import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class AddFoodView extends GetView<AdminController> {
  const AddFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [TextConst.iceCream, TextConst.burger, TextConst.salad, TextConst.pizza];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined, color: ColorConst.adminAppBarIcon, size: 24.r), onPressed: () => Get.back()),
        centerTitle: true,
        title: Text(TextConst.addItem, style: AppWidget.HeadlineTextFieldStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TextConst.uploadPicture, style: AppWidget.semiBoldFieldStyle()),
              SizedBox(height: 20.h),
              Obx(() => GestureDetector(
                onTap: () => controller.getImage(),
                child: Center(
                  child: Material(
                    elevation: 4, borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: 150.r, height: 150.r,
                      decoration: BoxDecoration(border: Border.all(color: ColorConst.black, width: 1.5.w), borderRadius: BorderRadius.circular(20.r)),
                      child: controller.selectedImage.value == null 
                        ? Icon(Icons.camera_alt_outlined, color: ColorConst.black, size: 30.r)
                        : ClipRRect(borderRadius: BorderRadius.circular(20.r), child: Image.file(controller.selectedImage.value!, fit: BoxFit.cover)),
                    ),
                  ),
                ),
              )),
              SizedBox(height: 30.h),
              _buildInputLabel(TextConst.itemName),
              _buildTextField(controller.foodNameController, TextConst.itemHint),
              SizedBox(height: 30.h),
              _buildInputLabel(TextConst.itemPrice),
              _buildTextField(controller.foodPriceController, TextConst.enterPrice),
              SizedBox(height: 30.h),
              _buildInputLabel(TextConst.itemDetails),
              _buildTextField(controller.foodDetailController, TextConst.enterDetails, maxLines: 6),
              SizedBox(height: 20.h),
              Text(TextConst.selectCategory, style: AppWidget.semiBoldFieldStyle()),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.infinity,
                decoration: BoxDecoration(color: ColorConst.adminFieldBg, borderRadius: BorderRadius.circular(10.r)),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<String>(
                    items: categories.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(fontSize: 18.sp, color: ColorConst.black)))).toList(),
                    onChanged: (value) => controller.selectedCategory.value = value!,
                    dropdownColor: ColorConst.white, iconSize: 36.r, icon: const Icon(Icons.arrow_drop_down, color: ColorConst.black),
                    value: controller.selectedCategory.value,
                  )),
                ),
              ),
              SizedBox(height: 30.h),
              Obx(() => GestureDetector(
                onTap: () => controller.uploadFoodItem(),
                child: Center(
                  child: Material(
                    elevation: 5, borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      width: 150.w, decoration: BoxDecoration(color: ColorConst.black, borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: controller.isLoading.value 
                          ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: ColorConst.white, strokeWidth: 2))
                          : Text(TextConst.add, style: TextStyle(color: ColorConst.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidget.semiBoldFieldStyle()),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      decoration: BoxDecoration(color: ColorConst.adminFieldBg, borderRadius: BorderRadius.circular(10.r)),
      child: TextField(
        controller: controller, maxLines: maxLines,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          border: InputBorder.none, hintText: hint,
          hintStyle: TextStyle(color: ColorConst.black38, fontSize: 18.sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
