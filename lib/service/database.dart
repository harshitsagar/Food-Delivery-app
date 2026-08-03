import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap) ;

  }

  UpdateUserWallet(String id, String amount) async {

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({"Wallet" : amount});

  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {

    return await FirebaseFirestore.instance
        .collection(name)
        .add(userInfoMap) ;

  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {

    return await FirebaseFirestore.instance.collection(name).snapshots() ;

  }

  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap) ;

  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {

    return await FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots() ;

  }

  // Add this new method to clear the cart
  Future<void> clearCart(String userId) async {
    // Get all documents in the user's cart
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .get();

    // Delete each document in the cart
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch delete
    await batch.commit();
  }


}





