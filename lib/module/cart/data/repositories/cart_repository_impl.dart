import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Stream<QuerySnapshot>> getCartItems(String userId) {
    return remoteDataSource.getCartItems(userId);
  }

  @override
  Future<void> addToCart(CartItemEntity item, String userId) {
    final model = CartItemModel(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      total: item.total,
      image: item.image,
    );
    return remoteDataSource.addToCart(model, userId);
  }

  @override
  Future<void> clearCart(String userId) {
    return remoteDataSource.clearCart(userId);
  }

  @override
  Future<void> placeOrder(Map<String, dynamic> orderData) {
    return remoteDataSource.placeOrder(orderData);
  }

  @override
  Future<void> updateWallet(String userId, String amount) {
    return remoteDataSource.updateWallet(userId, amount);
  }
}
