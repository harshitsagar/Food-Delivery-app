import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quick_eats_app/pages/auth_pages/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailController = new TextEditingController() ;

  String email = "" ;

  final _formkey = GlobalKey<FormState>() ;

  resetPassword() async {

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Password Reset Email has been sent to your email !",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black),
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
                fontSize: 18,
                color: Colors.white),
          ),
        ),
      );

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(

        child: Column(

          children: [

            SizedBox(height: 70,),

            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            SizedBox(height: 30,),

            Expanded(
                child: Form(
                    key: _formkey,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ListView(

                          children: [

                            Container(
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: TextFormField(

                                controller: emailController,
                                validator: (value) {

                                  if(value == null || value.isEmpty) {
                                    return "Please Enter the Email\n" ;
                                  }

                                  return null ;

                                },

                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Enter your email here",
                                  hintStyle: TextStyle(fontSize: 18, color: Colors.white,),
                                  prefixIcon: Icon(Icons.person, color: Colors.white70, size: 30,),
                                  border: InputBorder.none,
                                ),

                              ),

                            ),

                            SizedBox(height: 40,),

                            Container(

                              width: 140,
                              padding: EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: GestureDetector(

                                onTap: () {

                                  if(_formkey.currentState!.validate()) {

                                    setState(() {
                                      email = emailController.text ;
                                    });

                                    resetPassword() ;

                                  }

                                },

                                child: Center(
                                    child: Text(
                                      "Send email",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                ),
                              ),
                            ),

                            SizedBox(height: 500,),

                            Row(
                              
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 5,),

                                GestureDetector(
                                  
                                  onTap: () {
                                    
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                                    
                                  },
                                  
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 184, 166, 6),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,

                                    ),
                                  ),
                                ),

                              ],
                            ),

                          ],

                        ),

                    ),
                ),
            ),


          ],

        ),

      ),


    );
  }
}
