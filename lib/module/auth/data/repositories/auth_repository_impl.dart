import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserCredential> loginWithEmail(String email, String password) {
    return remoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) {
    return remoteDataSource.signUpWithEmail(email, password);
  }

  @override
  Future<UserCredential?> loginWithGoogle() {
    return remoteDataSource.loginWithGoogle();
  }

  @override
  Future<void> resetPassword(String email) {
    return remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> saveUserToFirestore(UserEntity user) {
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      wallet: user.wallet,
      loginType: user.loginType,
    );
    return remoteDataSource.saveUser(userModel);
  }

  @override
  Future<UserEntity?> getUserFromFirestore(String userId) {
    return remoteDataSource.getUser(userId);
  }
}
