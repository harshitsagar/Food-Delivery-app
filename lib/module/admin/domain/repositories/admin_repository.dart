import 'dart:io';

abstract class AdminRepository {
  Future<bool> loginAdmin(String username, String password);
  Future<void> addFoodItem(Map<String, dynamic> foodData, String category);
  Future<String> uploadFoodImage(File imageFile);
}
