import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/core/services/auth_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:random_string/random_string.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';

class ProfileController extends GetxController {
  var profilePic = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    profilePic.value = await SharedPreferenceHelper.getUserProfile() ?? '';
    name.value = await SharedPreferenceHelper.getUserName() ?? '';
    email.value = await SharedPreferenceHelper.getUserEmail() ?? '';
    isLoading.value = false;
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
        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage.value!);
        var downloadUrl = await (await task).ref.getDownloadURL();
        
        await SharedPreferenceHelper.saveUserProfile(downloadUrl);
        profilePic.value = downloadUrl;
        Get.snackbar("Success", "Image uploaded successfully!");
      } catch (e) {
        Get.snackbar("Error", "Image upload failed");
      }
    }
  }

  Future<void> logout() async {
    await AuthMethods().signOut();
    Get.offAllNamed(AppRoute.login);
  }

  Future<void> deleteAccount() async {
    await AuthMethods().deleteUser();
    Get.offAllNamed(AppRoute.login);
  }
}
