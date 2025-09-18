import 'dart:io' show Platform;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/pages/auth_pages/forgotpassword.dart';
import 'package:quick_eats_app/pages/auth_pages/signup.dart';
import 'package:quick_eats_app/pages/bottom_nav/bottom_nav.dart';
import 'package:quick_eats_app/pages/notification_screen.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// import 'package:twitter_login/twitter_login.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String email = "", password = "";
  TextEditingController useremailController = new TextEditingController();
  TextEditingController userpasswordController = new TextEditingController();

  String? id , name , wallet ;

  final _formkey = GlobalKey<FormState>();

  getTheSharedPref() async {

    id = await SharedPreferenceHelper().getUserId() ;
    name = await SharedPreferenceHelper().getUserName() ;
    wallet = await SharedPreferenceHelper().getUserWallet() ;

    setState(() {

    });

  }

  onTheLoad() async {

    await getTheSharedPref();
    setState(() {});

  }

  @override
  void initState() {
    super.initState();

    onTheLoad();

  }

  // Sign in with Google .....
  loginWithGoogle() async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Google Sign-In canceled.")));
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      if (googleSignInAuthentication.idToken == null ||
          googleSignInAuthentication.accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Google authentication failed.")));
        return;
      }

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential userCredential = await auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("User is null, login failed.")));
        return;
      }

      // Store user details
      Map<String, dynamic> addUserInfo = {
        "Name": user.displayName ?? "Google User",
        "Email": user.email ?? "no-email@example.com",
        "Wallet": wallet,
        "Id": user.uid,
        "login": "Google",
      };

      await DatabaseMethods().addUserDetail(addUserInfo, user.uid);

      // Save user info locally
      await SharedPreferenceHelper().saveUserName(user.displayName ?? "Google User");
      await SharedPreferenceHelper().saveUserEmail(user.email ?? "no-email@example.com");
      await SharedPreferenceHelper().saveUserWallet(wallet?? '0');
      await SharedPreferenceHelper().saveUserId(user.uid);
      await SharedPreferenceHelper().saveUserLOGIN("Google");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.orangeAccent,
          content: Text("Logged In Successfully", style: TextStyle(fontSize: 20))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Error: ${e.toString()}")));
    }
  }


  // login with twitter .......
  /*
  signInWithTwitter() async {
    final TwitterLogin twitterLogin = TwitterLogin(
        apiKey: "0uXPNPfSfMUykAkJda1GTGocq",
        apiSecretKey: "vSHjMfkCOxr4DFdPM24t5Tlc3KFPBhpvTtp4QMvSIYKXmbqsDt",
        redirectURI: "socialauth://");

    final auth = FirebaseAuth.instance;
    final authResult = await twitterLogin.loginV2();

    if (authResult.status == TwitterLoginStatus.loggedIn) {
      try {

        final credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!);
        await auth.signInWithCredential(credential);

        // For Database Configurations .......
        final UserCredential userCredential = await auth.signInWithCredential(credential) ;
        final User? user = userCredential.user ;

        // Retrieve the email, username, and ID
        final String? email = user!.email;
        final String? username = user!.displayName;
        final String uid = user!.uid;
        final String login = "Twitter";


        Map<String, dynamic> addUserInfo = {

          "Name" : username,
          "Email" : email,
          "Wallet" : wallet,
          "Id" : uid,
          "login" : "Twitter"

        };

        await DatabaseMethods().addUserDetail(addUserInfo, uid);

        // now we save our info locally with the help of shared preferences ......
        await SharedPreferenceHelper().saveUserName(username!);
        await SharedPreferenceHelper().saveUserEmail(email==null ? "" : email);
        await SharedPreferenceHelper().saveUserWallet(wallet!);
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserLOGIN(login);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Logged In Successfully",
              style: TextStyle(fontSize: 20),
            )));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.red,
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 20),
            )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          content: Text(
            "Login Failed",
            style: TextStyle(fontSize: 20),
          )));
    }
  }

   */

  // Sign in with Apple .....
  signInWithApple() async {

    try {

      final FirebaseAuth _auth = FirebaseAuth.instance;

      if (Platform.isIOS || Platform.isMacOS) {

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential = OAuthProvider("https://fooddeliveryapp-65851.firebaseapp.com/__/auth/handler").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        final User? user = userCredential.user;

        // For Database Configurations .......
        // Retrieve the email, username, and ID
        final String? email = user!.email;
        final String? username = user!.displayName;
        final String uid = user!.uid;
        final String login = "Apple";


        Map<String, dynamic> addUserInfo = {

          "Name" : username,
          "Email" : email,
          "Wallet" : wallet,
          "Id" : uid,
          "login" : "Apple"

        };

        await DatabaseMethods().addUserDetail(addUserInfo, uid);

        // now we save our info locally with the help of shared preferences ......
        await SharedPreferenceHelper().saveUserName(username!);
        await SharedPreferenceHelper().saveUserEmail(email==null ? "" : email);
        await SharedPreferenceHelper().saveUserWallet(wallet!);
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserLOGIN(login);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Logged In Successfully",
              style: TextStyle(fontSize: 20),
            )));

      }

      else if (Platform.isAndroid || Platform.isWindows) {

        // For Android, you need to use a custom web authentication
        // This part requires additional setup and handling

        // Example for Android (not a full implementation)
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            redirectUri: Uri.parse('https://example.com/callbacks/sign_in_with_apple'),
            clientId: 'com.example.foodDeliveryApp',
          ),
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        final User? user = userCredential.user;

        // For Database Configurations .......
        // Retrieve the email, username, and ID
        final String? email = user!.email;
        final String? username = user!.displayName;
        final String uid = user!.uid;
        final String login = "Apple";

        Map<String, dynamic> addUserInfo = {

          "Name" : username,
          "Email" : email,
          "Wallet" : wallet,
          "Id" : uid,
          "login" : "Apple"

        };

        await DatabaseMethods().addUserDetail(addUserInfo, uid);

        // now we save our info locally with the help of shared preferences ......
        await SharedPreferenceHelper().saveUserName(username!);
        await SharedPreferenceHelper().saveUserEmail(email==null ? "" : email);
        await SharedPreferenceHelper().saveUserWallet(wallet!);
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserLOGIN(login);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Logged In Successfully",
              style: TextStyle(fontSize: 20),
            )));

      }

      else {

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential = OAuthProvider("https://fooddeliveryapp-65851.firebaseapp.com/__/auth/handler").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
        final User? user = userCredential.user;

        // For Database Configurations .......
        // Retrieve the email, username, and ID
        final String? email = user!.email;
        final String? username = user!.displayName;
        final String uid = user!.uid;
        final String login = "Apple";


        Map<String, dynamic> addUserInfo = {

          "Name" : username,
          "Email" : email,
          "Wallet" : wallet,
          "Id" : uid,
          "login" : "Apple"

        };

        await DatabaseMethods().addUserDetail(addUserInfo, uid);

        // now we save our info locally with the help of shared preferences ......
        await SharedPreferenceHelper().saveUserName(username!);
        await SharedPreferenceHelper().saveUserEmail(email==null ? "" : email);
        await SharedPreferenceHelper().saveUserWallet(wallet!);
        await SharedPreferenceHelper().saveUserId(uid);
        await SharedPreferenceHelper().saveUserLOGIN(login);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Logged In Successfully",
              style: TextStyle(fontSize: 20),
            )));

      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

  }
  
  // sign in with email and password ......
  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the logged in user
      User? user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // User doesn't exist in Firestore, create new record
          Map<String, dynamic> addUserInfo = {
            "Name": email.split('@')[0], // Default name from email
            "Email": email,
            "Wallet": "0",
            "Id": user.uid,
            "login": "Email",
          };

          await DatabaseMethods().addUserDetail(addUserInfo, user.uid);
        }

        // Save user info locally
        await SharedPreferenceHelper().saveUserId(user.uid);
        await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserLOGIN("Email");

        // Get name from Firestore or use email prefix as fallback
        String name = userDoc.exists ? userDoc.get('Name') : email.split('@')[0];
        await SharedPreferenceHelper().saveUserName(name);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotificationScreen()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Logged In Successfully",
              style: TextStyle(fontSize: 20),
            )));
      } else {
        throw Exception("User is null after login");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            e.toString(),
            style: TextStyle(fontSize: 18),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.orange, Colors.red]),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Text(""),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: ListView(
                children: [
                  Center(
                    child: Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width / 1.2,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Login ",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: useremailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Email';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: AppWidget.semiBoldFieldStyle(),
                                  prefixIcon: Icon(Icons.email_outlined)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: userpasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Password';
                                }

                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: AppWidget.semiBoldFieldStyle(),
                                  prefixIcon: Icon(Icons.password_outlined)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    email = useremailController.text;
                                    password = userpasswordController.text;
                                  });
                                }

                                userLogin();
                              },
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  width: 200,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.orange, Colors.red]),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Poppins1',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  // or continue with .......
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.black,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  // google + twitter + apple sign-In buttons .....
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      GestureDetector(
                        onTap: () async {
                          await loginWithGoogle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Image.asset(
                            'images/google_logo.png',
                            height: 35,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 50,
                      ),

                      // twitter button
                      GestureDetector(
                        onTap: () async {
                          // await signInWithTwitter();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Image.asset(
                            'images/twitter.png',
                            height: 35,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 50,
                      ),

                      // apple button
                      GestureDetector(
                        onTap: () async {
                          await signInWithApple();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: Image.asset(
                            'images/apple_logo.png',
                            height: 35,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 45,
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),

                        Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.blue,
                              fontWeight: FontWeight.w800),
                        ),

                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
