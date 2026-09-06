import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_eats_app/core/constant/color_const.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/push_notification_service.dart';
import '../../domain/usecases/profile_usecases.dart';

class ProfileController extends GetxController {
  final UploadProfileImageUseCase uploadProfileImageUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileController(
    this.uploadProfileImageUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
  );

  var profilePic = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var isNotificationsEnabled = false.obs;
  
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    checkNotificationStatus();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    profilePic.value = await SharedPreferenceHelper.getUserProfile() ?? '';
    name.value = await SharedPreferenceHelper.getUserName() ?? '';
    email.value = await SharedPreferenceHelper.getUserEmail() ?? '';
    isLoading.value = false;
  }

  Future<void> checkNotificationStatus() async {
    try {
      NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
      isNotificationsEnabled.value = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      isNotificationsEnabled.value = false;
    }
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        isNotificationsEnabled.value = true;
        Get.snackbar("Success", "Push notifications enabled!");
      } else {
        bool success = await PushNotificationService.requestPermissionAndGetToken();
        if (success) {
          isNotificationsEnabled.value = true;
          Get.snackbar("Success", "Push notifications enabled!");
        } else {
          isNotificationsEnabled.value = false;
          _showSettingsDialog();
        }
      }
    } else {
      isNotificationsEnabled.value = false;
      Get.snackbar("Notifications", "Push notifications disabled. You can re-enable them anytime.");
    }
  }

  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: const Text("Notifications Disabled"),
        content: const Text("Notification permissions are turned off in your device settings. Please enable them to receive updates."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConst.deepOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text("Open Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
        await uploadImage();
      }
    } catch (e) {
      Get.snackbar("Error", "Image selection failed");
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage.value != null) {
      try {
        String downloadUrl = await uploadProfileImageUseCase.execute(selectedImage.value!);
        await SharedPreferenceHelper.saveUserProfile(downloadUrl);
        profilePic.value = downloadUrl;
        Get.snackbar("Success", "Image uploaded successfully!");
      } catch (e) {
        Get.snackbar("Error", "Image upload failed");
      }
    }
  }

  Future<void> logout() async {
    await logoutUseCase.execute();
    Get.offAllNamed(AppRoute.login);
  }

  Future<void> deleteAccount() async {
    await deleteAccountUseCase.execute();
    Get.offAllNamed(AppRoute.login);
  }
}
