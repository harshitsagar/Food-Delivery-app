import 'dart:io';
import '../repositories/admin_repository.dart';

class AdminLoginUseCase {
  final AdminRepository repository;
  AdminLoginUseCase(this.repository);
  Future<bool> execute(String username, String password) => repository.loginAdmin(username, password);
}

class AddFoodItemUseCase {
  final AdminRepository repository;
  AddFoodItemUseCase(this.repository);
  Future<void> execute(Map<String, dynamic> foodData, String category) => repository.addFoodItem(foodData, category);
}

class UploadFoodImageUseCase {
  final AdminRepository repository;
  UploadFoodImageUseCase(this.repository);
  Future<String> execute(File imageFile) => repository.uploadFoodImage(imageFile);
}
