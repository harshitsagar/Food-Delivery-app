import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_eats_app/pages/auth_pages/login.dart';
import 'package:quick_eats_app/pages/bottom_nav/bottom_nav.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";

  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20),
            )));

        // For Database Configurations .......
        String Id = randomAlphaNumeric(10);
        final String login = "Email";

        Map<String, dynamic> addUserInfo = {

          "Name" : nameController.text,
          "Email" : emailController.text,
          "Wallet" : "0",
          "Id" : Id,
          "login" : "Email"

        };

        await DatabaseMethods().addUserDetail(addUserInfo, Id);

        // now we save our info locally with the help of shared preferences ......
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserLOGIN(login);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));

      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              e.toString(),
              style: TextStyle(
                fontSize: 18,
              ),
            )));

      }
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
              margin: EdgeInsets.only(top: 60, left: 20, right: 20),
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
                      height: MediaQuery.of(context).size.height / 1.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Sign up",
                              style: AppWidget.HeadlineTextFieldStyle(),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Name";
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: AppWidget.semiBoldFieldStyle(),
                                  prefixIcon: Icon(Icons.person_outlined)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter E-mail";
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
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Password ";
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
                              height: 80,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                    name = nameController.text;
                                    password = passwordController.text;
                                  });
                                }

                                registration();
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
                                      "SIGN UP",
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
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),

                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w900),
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
