import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/home_repository.dart';

class GetFoodItemsUseCase {
  final HomeRepository repository;

  GetFoodItemsUseCase(this.repository);

  Future<Stream<QuerySnapshot>> execute(String category) {
    return repository.getFoodItems(category);
  }
}
