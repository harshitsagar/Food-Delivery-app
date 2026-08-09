import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_eats_app/core/constant/app_url.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(AppUrl.usersCollection)
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection(AppUrl.usersCollection)
        .doc(id)
        .update({AppUrl.walletField: amount});
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(AppUrl.usersCollection)
        .doc(id)
        .collection(AppUrl.cartCollection)
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return FirebaseFirestore.instance
        .collection(AppUrl.usersCollection)
        .doc(id)
        .collection(AppUrl.cartCollection)
        .snapshots();
  }

  Future<void> clearCart(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .collection(AppUrl.cartCollection)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
