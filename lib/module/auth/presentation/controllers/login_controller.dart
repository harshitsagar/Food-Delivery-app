import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class LoginController extends GetxController {
  final useremailController = TextEditingController();
  final userpasswordController = TextEditingController();
  
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  RxBool obscureText = true.obs;
  RxBool loading = false.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    try {
      loading.value = true;
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        loading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential userCredential = await auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;

      if (user == null) {
        loading.value = false;
        return;
      }

      String? wallet = await SharedPreferenceHelper.getUserWallet();

      Map<String, dynamic> addUserInfo = {
        "Name": user.displayName ?? "Google User",
        "Email": user.email ?? "no-email@example.com",
        "Wallet": wallet ?? "0",
        "Id": user.uid,
        "login": "Google",
      };

      await DatabaseMethods().addUserDetail(addUserInfo, user.uid);

      await SharedPreferenceHelper.saveUserName(user.displayName ?? "Google User");
      await SharedPreferenceHelper.saveUserEmail(user.email ?? "no-email@example.com");
      await SharedPreferenceHelper.saveUserWallet(wallet ?? '0');
      await SharedPreferenceHelper.saveUserId(user.uid);
      await SharedPreferenceHelper.saveUserLOGIN("Google");

      loading.value = false;
      Get.offAllNamed(AppRoute.notifications);
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> userLogin(BuildContext context) async {
    String email = useremailController.text.trim();
    String password = userpasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter email and password", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          Map<String, dynamic> addUserInfo = {
            "Name": email.split('@')[0],
            "Email": email,
            "Wallet": "0",
            "Id": user.uid,
            "login": "Email",
          };
          await DatabaseMethods().addUserDetail(addUserInfo, user.uid);
        }

        await SharedPreferenceHelper.saveUserId(user.uid);
        await SharedPreferenceHelper.saveUserEmail(email);
        await SharedPreferenceHelper.saveUserWallet('0');
        await SharedPreferenceHelper.saveUserLOGIN("Email");

        String name = userDoc.exists ? userDoc.get('Name') : email.split('@')[0];
        await SharedPreferenceHelper.saveUserName(name);

        loading.value = false;
        Get.offAllNamed(AppRoute.notifications);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    useremailController.dispose();
    userpasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
