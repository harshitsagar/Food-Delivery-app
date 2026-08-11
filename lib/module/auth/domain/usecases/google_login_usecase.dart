import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<UserCredential?> execute() {
    return repository.loginWithGoogle();
  }
}
