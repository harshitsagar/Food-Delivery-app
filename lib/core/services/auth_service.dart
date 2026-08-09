import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    String? loginMethod = await SharedPreferenceHelper.getUserLOGIN();
    if (loginMethod == "Google") {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    String? loginMethod = await SharedPreferenceHelper.getUserLOGIN();
    if (loginMethod == "Google") {
      await _googleSignIn.signOut();
    }
    User? user = _auth.currentUser;
    await user?.delete();
  }
}
