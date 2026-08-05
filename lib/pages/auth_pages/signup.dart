import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_eats_app/pages/auth_pages/login.dart';
import 'package:quick_eats_app/pages/bottom_nav/bottom_nav.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  bool _obscureText = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  loginWithGoogle() async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) return;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      final UserCredential userCredential = await auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;

      if (user == null) return;

      Map<String, dynamic> addUserInfo = {
        "Name": user.displayName ?? "Google User",
        "Email": user.email ?? "no-email@example.com",
        "Wallet": "0",
        "Id": user.uid,
        "login": "Google",
      };

      await DatabaseMethods().addUserDetail(addUserInfo, user.uid);

      await SharedPreferenceHelper().saveUserName(user.displayName ?? "Google User");
      await SharedPreferenceHelper().saveUserEmail(user.email ?? "no-email@example.com");
      await SharedPreferenceHelper().saveUserWallet('0');
      await SharedPreferenceHelper().saveUserId(user.uid);
      await SharedPreferenceHelper().saveUserLOGIN("Google");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Error: ${e.toString()}")));
    }
  }

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = userCredential.user!.uid;
      const String login = "Email";

      Map<String, dynamic> addUserInfo = {
        "Name": nameController.text,
        "Email": emailController.text,
        "Wallet": "0",
        "Id": userId,
        "login": "Email"
      };

      await DatabaseMethods().addUserDetail(addUserInfo, userId);

      await SharedPreferenceHelper().saveUserName(nameController.text);
      await SharedPreferenceHelper().saveUserEmail(emailController.text);
      await SharedPreferenceHelper().saveUserWallet('0');
      await SharedPreferenceHelper().saveUserId(userId);
      await SharedPreferenceHelper().saveUserLOGIN(login);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(e.toString(), style: const TextStyle(fontSize: 18))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // FIXED BACKGROUND: Does not move or resize
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height, // Total screen height
            child: Image.asset(
              "assets/images/auth/auth_bg.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter, // Anchors the image to the top
            ),
          ),
          
          // SCROLLABLE FORM: Moves up when keyboard opens
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.46),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, left: 25, right: 25, bottom: 35),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 25),
                        RichText(
                          text: const TextSpan(
                            text: 'Sign ',
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'up', style: TextStyle(color: Colors.orangeAccent)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Create your account and get started",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(height: 30),
                        
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Please Enter Name";
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: const Icon(Icons.person_outline, color: Colors.orangeAccent),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Please Enter Email";
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.orangeAccent),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Please Enter Password";
                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.orangeAccent),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() => _obscureText = !_obscureText),
                              child: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.orangeAccent)),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                name = nameController.text;
                                password = passwordController.text;
                              });
                              registration();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: const Center(
                              child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("Or continue with", style: TextStyle(color: Colors.grey.shade500, fontSize: 12))),
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        
                        GestureDetector(
                          onTap: () async => await loginWithGoogle(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/google_logo.png', height: 22),
                                const SizedBox(width: 10),
                                const Text("Continue with Google", style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? ", style: TextStyle(color: Colors.black87, fontSize: 14)),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn())),
                              child: const Text("Login", style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(MediaQuery.of(context).size.width, 80),
                        painter: BottomWavePainter(),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.fastfood_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24),
                            Icon(Icons.local_pizza_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24),
                            Icon(Icons.lunch_dining_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24),
                            Icon(Icons.icecream_outlined, color: Colors.orangeAccent.withOpacity(0.3), size: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.orangeAccent.withOpacity(0.15)..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.1, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
