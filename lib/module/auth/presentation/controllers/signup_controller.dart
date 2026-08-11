import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/core/constant/text_const.dart';
import 'package:quick_eats_app/core/routes/app_routes.dart';
import 'package:quick_eats_app/core/services/database_service.dart';
import 'package:quick_eats_app/core/services/shared_pref_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocusNode = FocusNode();
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

      Map<String, dynamic> addUserInfo = {
        "Name": user.displayName ?? "Google User",
        "Email": user.email ?? "no-email@example.com",
        "Wallet": "0",
        "Id": user.uid,
        "login": "Google",
      };

      await DatabaseMethods().addUserDetail(addUserInfo, user.uid);

      await SharedPreferenceHelper.saveUserName(user.displayName ?? "Google User");
      await SharedPreferenceHelper.saveUserEmail(user.email ?? "no-email@example.com");
      await SharedPreferenceHelper.saveUserWallet('0');
      await SharedPreferenceHelper.saveUserId(user.uid);
      await SharedPreferenceHelper.saveUserLOGIN("Google");

      loading.value = false;
      Get.offAllNamed(AppRoute.notifications);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> registration(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar(TextConst.error, TextConst.fillAllFields, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      loading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;
      const String login = "Email";

      Map<String, dynamic> addUserInfo = {
        "Name": name,
        "Email": email,
        "Wallet": "0",
        "Id": userId,
        "login": "Email"
      };

      await DatabaseMethods().addUserDetail(addUserInfo, userId);

      await SharedPreferenceHelper.saveUserName(name);
      await SharedPreferenceHelper.saveUserEmail(email);
      await SharedPreferenceHelper.saveUserWallet('0');
      await SharedPreferenceHelper.saveUserId(userId);
      await SharedPreferenceHelper.saveUserLOGIN(login);

      loading.value = false;
      Get.offAllNamed(AppRoute.notifications);
    } catch (e) {
      loading.value = false;
      Get.snackbar(TextConst.error, e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
