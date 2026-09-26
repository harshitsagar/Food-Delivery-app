import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_eats_app/core/constant/app_url.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<Stream<QuerySnapshot>> getCartItems(String userId);
  Future<void> addToCart(CartItemModel item, String userId);
  Future<void> clearCart(String userId);
  Future<void> placeOrder(Map<String, dynamic> orderData);
  Future<void> updateWallet(String userId, String amount);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Stream<QuerySnapshot>> getCartItems(String userId) async {
    return _firestore
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .collection(AppUrl.cartCollection)
        .snapshots();
  }

  @override
  Future<void> addToCart(CartItemModel item, String userId) async {
    await _firestore
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .collection(AppUrl.cartCollection)
        .add(item.toJson());
  }

  @override
  Future<void> clearCart(String userId) async {
    final querySnapshot = await _firestore
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .collection(AppUrl.cartCollection)
        .get();

    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    await _firestore.collection('orders').doc(orderData['orderId']).set(orderData);
  }

  @override
  Future<void> updateWallet(String userId, String amount) async {
    await _firestore
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .update({AppUrl.walletField: amount});
  }
}
