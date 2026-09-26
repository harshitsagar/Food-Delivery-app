import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeRemoteDataSource {
  Future<Stream<QuerySnapshot>> getFoodItems(String category);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Stream<QuerySnapshot>> getFoodItems(String category) async {
    return _firestore.collection(category).snapshots();
  }
}
