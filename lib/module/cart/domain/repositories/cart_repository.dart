import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Stream<QuerySnapshot>> getCartItems(String userId);
  Future<void> addToCart(CartItemEntity item, String userId);
  Future<void> clearCart(String userId);
  Future<void> placeOrder(Map<String, dynamic> orderData);
  Future<void> updateWallet(String userId, String amount);
}
