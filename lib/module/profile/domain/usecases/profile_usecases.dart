import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  final ProfileRepository repository;
  UploadProfileImageUseCase(this.repository);
  Future<String> execute(File imageFile) => repository.uploadProfileImage(imageFile);
}

class LogoutUseCase {
  final ProfileRepository repository;
  LogoutUseCase(this.repository);
  Future<void> execute() => repository.logout();
}

class DeleteAccountUseCase {
  final ProfileRepository repository;
  DeleteAccountUseCase(this.repository);
  Future<void> execute() => repository.deleteAccount();
}
