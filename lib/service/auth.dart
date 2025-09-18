import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:twitter_login/twitter_login.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance ;
  final GoogleSignIn _googleSignIn = GoogleSignIn() ;
  // final TwitterLogin _twitterLogin = TwitterLogin(
  //     apiKey: "0uXPNPfSfMUykAkJda1GTGocq",
  //     apiSecretKey: "vSHjMfkCOxr4DFdPM24t5Tlc3KFPBhpvTtp4QMvSIYKXmbqsDt",
  //     redirectURI: "socialauth://"
  // );


  getCurrentUser() async {

    return await _auth.currentUser ;

  }

  Future SignOut() async {

    String? loginMethod = await SharedPreferenceHelper().getUserLOGIN() ;

    if(loginMethod == "Google"){

      // Sign out from Google
      await _googleSignIn.signOut();

    }

    else {

      // Sign out from Firebase (covers email/password and all other providers)
      await _auth.signOut();

    }

  }

  Future deleteUser() async {

    String? loginMethod = await SharedPreferenceHelper().getUserLOGIN() ;

    if(loginMethod == "Google"){

      // Sign out from Google
      await _googleSignIn.signOut();
      User? user = await FirebaseAuth.instance.currentUser ;
      user?.delete() ;

    }

    else {

      // Sign out from Firebase (covers email/password and all other providers)
      User? user = await FirebaseAuth.instance.currentUser ;
      user?.delete() ;

    }

  }




}