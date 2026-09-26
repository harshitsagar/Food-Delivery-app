import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserCredential> loginWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
  Future<UserCredential?> loginWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> saveUserToFirestore(UserEntity user);
  Future<UserEntity?> getUserFromFirestore(String userId);
}
