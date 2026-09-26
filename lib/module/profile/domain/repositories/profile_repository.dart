import 'dart:io';

abstract class ProfileRepository {
  Future<String> uploadProfileImage(File imageFile);
  Future<void> logout();
  Future<void> deleteAccount();
}
