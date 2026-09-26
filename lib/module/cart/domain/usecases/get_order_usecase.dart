import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/cart_repository.dart';

class GetOrderUseCase {
  final CartRepository repository;
  GetOrderUseCase(this.repository);
  Future<Stream<DocumentSnapshot>> execute(String orderId) async {
    return FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots();
  }
}
