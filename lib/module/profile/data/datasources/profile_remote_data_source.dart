import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';
import 'package:random_string/random_string.dart';

abstract class ProfileRemoteDataSource {
  Future<String> uploadImage(File imageFile);
  Future<void> logout();
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<String> uploadImage(File imageFile) async {
    String addId = randomAlphaNumeric(10);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId);
    final UploadTask task = firebaseStorageRef.putFile(imageFile);
    var downloadUrl = await (await task).ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<void> logout() async {
    String? loginMethod = await SharedPreferenceHelper.getUserLOGIN();
    if (loginMethod == "Google") {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    String? loginMethod = await SharedPreferenceHelper.getUserLOGIN();
    if (loginMethod == "Google") {
      await _googleSignIn.signOut();
    }
    User? user = _auth.currentUser;
    await user?.delete();
  }
}
