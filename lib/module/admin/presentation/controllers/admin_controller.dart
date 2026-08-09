import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:random_string/random_string.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';

class AdminController extends GetxController {
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
      var snapshot = await FirebaseFirestore.instance.collection("Admin").get();
      bool success = false;
      for (var result in snapshot.docs) {
        if (result.data()['id'] == usernameController.text.trim() &&
            result.data()['password'] == passwordController.text.trim()) {
          success = true;
          break;
        }
      }
      isLoading.value = false;
      if (success) {
        Get.toNamed(AppRoute.adminHome);
      } else {
        Get.snackbar("Error", "Invalid credentials", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Image selection failed");
    }
  }

  Future<void> uploadFoodItem() async {
    if (selectedImage.value != null && foodNameController.text.isNotEmpty && foodPriceController.text.isNotEmpty && foodDetailController.text.isNotEmpty) {
      try {
        isLoading.value = true;
        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage.value!);
        var downloadUrl = await (await task).ref.getDownloadURL();

        Map<String, dynamic> addItem = {
          "Image": downloadUrl,
          "Name": foodNameController.text,
          "Price": foodPriceController.text,
          "Detail": foodDetailController.text
        };

        await DatabaseMethods().addFoodItem(addItem, selectedCategory.value);
        isLoading.value = false;
        Get.snackbar("Success", "Food item added successfully!", backgroundColor: Colors.green, colorText: Colors.white);
        
        // Reset fields
        foodNameController.clear();
        foodPriceController.clear();
        foodDetailController.clear();
        selectedImage.value = null;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to add food item");
      }
    } else {
      Get.snackbar("Error", "Please fill all fields and select an image");
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
