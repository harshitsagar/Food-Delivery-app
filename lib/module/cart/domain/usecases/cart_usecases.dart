import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;
  GetCartItemsUseCase(this.repository);
  Future<Stream<QuerySnapshot>> execute(String userId) => repository.getCartItems(userId);
}

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);
  Future<void> execute(CartItemEntity item, String userId) => repository.addToCart(item, userId);
}

class ClearCartUseCase {
  final CartRepository repository;
  ClearCartUseCase(this.repository);
  Future<void> execute(String userId) => repository.clearCart(userId);
}

class PlaceOrderUseCase {
  final CartRepository repository;
  PlaceOrderUseCase(this.repository);
  Future<void> execute(Map<String, dynamic> orderData) => repository.placeOrder(orderData);
}

class UpdateWalletUseCase {
  final CartRepository repository;
  UpdateWalletUseCase(this.repository);
  Future<void> execute(String userId, String amount) => repository.updateWallet(userId, amount);
}
