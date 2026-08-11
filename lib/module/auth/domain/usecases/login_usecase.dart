import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserCredential> execute(String email, String password) {
    return repository.loginWithEmail(email, password);
  }
}
