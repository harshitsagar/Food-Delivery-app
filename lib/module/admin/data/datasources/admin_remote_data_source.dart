import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

abstract class AdminRemoteDataSource {
  Future<bool> loginAdmin(String username, String password);
  Future<void> addFoodItem(Map<String, dynamic> foodData, String category);
  Future<String> uploadImage(File imageFile);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<bool> loginAdmin(String username, String password) async {
    var snapshot = await _firestore.collection("Admin").get();
    for (var result in snapshot.docs) {
      if (result.data()['id'] == username && result.data()['password'] == password) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> addFoodItem(Map<String, dynamic> foodData, String category) async {
    await _firestore.collection(category).add(foodData);
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    String addId = randomAlphaNumeric(10);
    Reference firebaseStorageRef = _storage.ref().child("blogImages").child(addId);
    final UploadTask task = firebaseStorageRef.putFile(imageFile);
    var downloadUrl = await (await task).ref.getDownloadURL();
    return downloadUrl;
  }
}
