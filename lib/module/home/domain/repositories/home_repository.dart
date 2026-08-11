import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeRepository {
  Future<Stream<QuerySnapshot>> getFoodItems(String category);
}
