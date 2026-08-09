import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_eats_app/module/admin/presentation/controllers/admin_controller.dart';
import 'package:quick_eats_app/core/widget/widget_support.dart';

class AddFoodView extends GetView<AdminController> {
  const AddFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined, color: const Color(0xFF373866), size: 24.r), onPressed: () => Get.back()),
        centerTitle: true,
        title: Text('Add Item', style: AppWidget.HeadlineTextFieldStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload the Item Picture", style: AppWidget.semiBoldFieldStyle()),
              SizedBox(height: 20.h),
              Obx(() => GestureDetector(
                onTap: () => controller.getImage(),
                child: Center(
                  child: Material(
                    elevation: 4, borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      width: 150.r, height: 150.r,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5.w), borderRadius: BorderRadius.circular(20.r)),
                      child: controller.selectedImage.value == null 
                        ? Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30.r)
                        : ClipRRect(borderRadius: BorderRadius.circular(20.r), child: Image.file(controller.selectedImage.value!, fit: BoxFit.cover)),
                    ),
                  ),
                ),
              )),
              SizedBox(height: 30.h),
              _buildInputLabel("Items Name"),
              _buildTextField(controller.foodNameController, "eg : Ice-cream, Burger, Salad, Pizza"),
              SizedBox(height: 30.h),
              _buildInputLabel("Items Price"),
              _buildTextField(controller.foodPriceController, "Enter Item Price"),
              SizedBox(height: 30.h),
              _buildInputLabel("Items Details"),
              _buildTextField(controller.foodDetailController, "Enter Item Details", maxLines: 6),
              SizedBox(height: 20.h),
              Text("Select Category", style: AppWidget.semiBoldFieldStyle()),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10.r)),
                child: DropdownButtonHideUnderline(
                  child: Obx(() => DropdownButton<String>(
                    items: categories.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(fontSize: 18.sp, color: Colors.black)))).toList(),
                    onChanged: (value) => controller.selectedCategory.value = value!,
                    dropdownColor: Colors.white, iconSize: 36.r, icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                      width: 150.w, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
                      child: Center(
                        child: controller.isLoading.value 
                          ? SizedBox(height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("Add", style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
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
      decoration: BoxDecoration(color: const Color(0xFFececf8), borderRadius: BorderRadius.circular(10.r)),
      child: TextField(
        controller: controller, maxLines: maxLines,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          border: InputBorder.none, hintText: hint,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 18.sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}
