import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_admin.dart';
// import 'package:food_delivery_app/admin/home_admin.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>() ;
  TextEditingController usernameController = TextEditingController() ;
  TextEditingController userpasswordController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xFFededeb),

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(

        child: Stack(

          children: [

            Container(

              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
              padding: EdgeInsets.only(top: 45, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(

                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.orange, Colors.red]
                  ),
                
                borderRadius: BorderRadius.vertical(top: Radius.elliptical(MediaQuery.of(context).size.width,110)),

              ),
            ),

            Container(

              margin: EdgeInsets.only(left: 30, right: 30, top: 40),
              child: Form(
                  key: _formkey,
                  child: ListView(

                    children: [

                      Center(child: Text("Let's start with\nSeller!", style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),)),

                      SizedBox(height: 30,),

                      Material(

                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(

                          height: MediaQuery.of(context).size.height/2.2,

                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(

                            children: [

                              SizedBox(height: 50,),

                              Container(

                                padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromARGB(255, 51, 51, 49)),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Center(
                                  child: TextFormField(
                                    controller: usernameController,
                                    validator: (value) {

                                      if(value == null || value.isEmpty) {
                                        return 'Please Enter the Username' ;
                                      }

                                    },

                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 51, 51, 49), fontSize: 18),
                                    ),

                                  ),
                                ),

                              ),

                              SizedBox(height: 30,),

                              Container(

                                padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromARGB(255, 51, 51, 49)),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Center(
                                  child: TextFormField(
                                    controller: userpasswordController,
                                    validator: (value) {

                                      if(value == null || value.isEmpty) {
                                        return 'Please Enter the Password' ;
                                      }

                                    },

                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 51, 51, 49), fontSize: 18),
                                    ),

                                  ),
                                ),

                              ),

                              SizedBox(height: 50,),

                              GestureDetector(

                                onTap: () {

                                  LoginAdmin() ;

                                },

                                child: Container(

                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            // Colors.blue,
                                            Colors.orange,
                                            Colors.red
                                          ]
                                      ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),

                                  child: Center(
                                    child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                                  ),

                                ),
                              ),

                            ],

                          ),

                        ),

                      ),


                    ],

                  )
              ),

            ),


          ],

        ),

      ),


    );
  }

  LoginAdmin() {

    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {

      snapshot.docs.forEach((result) {

        if(result.data()['id']!=usernameController.text.trim()) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1500),
              backgroundColor: Colors.redAccent,
              content: Text(
                "Please enter a correct username !",
                style: TextStyle(fontSize: 20),
              )));

        }

        else if(result.data()['password']!=userpasswordController.text.trim()) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1500),
              backgroundColor: Colors.redAccent,
              content: Text(
                "Please enter a correct password !",
                style: TextStyle(fontSize: 20),
              )));

        }

        else {

          Route route = MaterialPageRoute(builder: (context) => HomeAdmin());
          Navigator.push(context, route);

        }

      });

    });
    
    
  }


}
