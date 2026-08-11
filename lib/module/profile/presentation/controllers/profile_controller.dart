import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
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
