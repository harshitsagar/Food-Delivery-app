import 'dart:io';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> uploadProfileImage(File imageFile) {
    return remoteDataSource.uploadImage(imageFile);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> deleteAccount() {
    return remoteDataSource.deleteAccount();
  }
}
