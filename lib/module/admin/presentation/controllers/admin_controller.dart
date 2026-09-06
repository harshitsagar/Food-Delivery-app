import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/notification_helper.dart';
import '../../domain/usecases/admin_usecases.dart';

class AdminController extends GetxController {
  final AdminLoginUseCase adminLoginUseCase;
  final AddFoodItemUseCase addFoodItemUseCase;
  final UploadFoodImageUseCase uploadFoodImageUseCase;

  AdminController(
    this.adminLoginUseCase,
    this.addFoodItemUseCase,
    this.uploadFoodImageUseCase,
  );

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  // For Add Food
  final foodNameController = TextEditingController();
  final foodPriceController = TextEditingController();
  final foodDetailController = TextEditingController();
  var selectedCategory = 'Ice-cream'.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;

  Future<void> loginAdmin() async {
    try {
      isLoading.value = true;
      bool success = await adminLoginUseCase.execute(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      isLoading.value = false;
      if (success) {
        Get.toNamed(AppRoute.adminHome);
      } else {
        Get.snackbar(TextConst.error, TextConst.invalidCredentials, backgroundColor: ColorConst.red, colorText: ColorConst.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(TextConst.error, e.toString());
    }
  }

  Future<void> getImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(TextConst.error, TextConst.imageSelectionFailed);
    }
  }

  Future<void> uploadFoodItem() async {
    if (selectedImage.value != null && foodNameController.text.isNotEmpty && foodPriceController.text.isNotEmpty && foodDetailController.text.isNotEmpty) {
      try {
        isLoading.value = true;
        String downloadUrl;
        try {
          downloadUrl = await uploadFoodImageUseCase.execute(selectedImage.value!);
        } catch (storageError) {
          print("Firebase Storage upload error: $storageError");
          // Dynamic category-based fallback image when Firebase Storage is restricted on Spark plan
          downloadUrl = _getCategoryFallbackImage(selectedCategory.value);
        }

        Map<String, dynamic> addItem = {
          "Image": downloadUrl,
          "Name": foodNameController.text,
          "Price": foodPriceController.text,
          "Detail": foodDetailController.text
        };

        await addFoodItemUseCase.execute(addItem, selectedCategory.value);

        String foodName = foodNameController.text;
        await NotificationHelper.showInAppNotification(
          title: "Craving Something New? 🍕",
          body: "A fresh new dish '$foodName' has just been added to the menu in ${selectedCategory.value}!",
          route: AppRoute.home,
        );

        isLoading.value = false;
        Get.snackbar(TextConst.success, TextConst.foodItemAddedSuccess, backgroundColor: ColorConst.green, colorText: ColorConst.white);
        
        // Reset fields
        foodNameController.clear();
        foodPriceController.clear();
        foodDetailController.clear();
        selectedImage.value = null;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(TextConst.error, TextConst.foodItemAddFailed);
      }
    } else {
      Get.snackbar(TextConst.error, TextConst.fillAllFields);
    }
  }

  String _getCategoryFallbackImage(String category) {
    switch (category.toLowerCase()) {
      case 'ice-cream':
      case 'icecream':
        return "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500";
      case 'pizza':
        return "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500";
      case 'burger':
        return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500";
      case 'salad':
        return "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500";
      default:
        return "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500";
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    foodNameController.dispose();
    foodPriceController.dispose();
    foodDetailController.dispose();
    super.onClose();
  }
}
