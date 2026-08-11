import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_eats_app/core/constant/app_url.dart';

abstract class WalletRemoteDataSource {
  Future<void> updateWallet(String userId, String amount);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> updateWallet(String userId, String amount) async {
    await _firestore
        .collection(AppUrl.usersCollection)
        .doc(userId)
        .update({AppUrl.walletField: amount});
  }
}
