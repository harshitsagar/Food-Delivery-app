import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<UserEntity?> execute(String userId) {
    return repository.getUserFromFirestore(userId);
  }
}
