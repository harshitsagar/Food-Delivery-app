import 'dart:io';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> loginAdmin(String username, String password) {
    return remoteDataSource.loginAdmin(username, password);
  }

  @override
  Future<void> addFoodItem(Map<String, dynamic> foodData, String category) {
    return remoteDataSource.addFoodItem(foodData, category);
  }

  @override
  Future<String> uploadFoodImage(File imageFile) {
    return remoteDataSource.uploadImage(imageFile);
  }
}
