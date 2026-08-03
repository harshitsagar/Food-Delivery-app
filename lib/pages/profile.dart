import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/admin/admin_login.dart';
import 'package:quick_eats_app/pages/auth_pages/login.dart';
import 'package:quick_eats_app/service/auth.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:random_string/random_string.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String? profile , name , email ;
  final ImagePicker _picker = ImagePicker() ;
  File? selectedImage ;

  getTheSharedPrefs() async {

    profile = await SharedPreferenceHelper().getUserProfile() ;
    name = await SharedPreferenceHelper().getUserName() ;
    email = await SharedPreferenceHelper().getUserEmail() ;

    setState(() {

    });

  }

  onThisLoad() async {

    await getTheSharedPrefs() ;
    setState(() {

    });

  }

  // For Feteching the image from the gallery ....
  Future getImage() async {

    try {

      var image = await _picker.pickImage(source: ImageSource.gallery) ;

      selectedImage = File(image!.path) ;

      setState(() {
        uploadItem();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.green,
        content: Text(
          "Image uploaded !",
          style: TextStyle(fontSize: 20),
        ),
      ));

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.redAccent,
        content: Text(
          "Image not uploaded !",
          style: TextStyle(fontSize: 20),
        ),
      ));

    }

  }

  uploadItem() async {

    if(selectedImage!=null) {

      String addId = randomAlphaNumeric(10) ;

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId) ;

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!) ;

      var downloadUrl = await(await task).ref.getDownloadURL() ;

      await SharedPreferenceHelper().saveUserProfile(downloadUrl) ;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.green,
          content: Text(
            "Image uploaded !",
            style: TextStyle(fontSize: 20),
          )));

      setState(() {

      });

    }

    else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.redAccent,
          content: Text(
            "Image not uploaded !",
            style: TextStyle(fontSize: 20),
          )));

    }

  }


  @override
  void initState() {
    onThisLoad() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: name==null
          ? Center(child: CircularProgressIndicator())
          : Container(

        child: Column(

          children: [

            Stack(

              children: [

                Container(

                  padding: EdgeInsets.only(top: 45, left: 20, right: 20),
                  height: MediaQuery.of(context).size.height/4.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105)
                      )
                  ),
                ),

                Center(
                  child: Container(

                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/7),
                    child: Material(

                      elevation: 10,
                      borderRadius: BorderRadius.circular(80),

                      child: ClipRRect(

                        borderRadius: BorderRadius.circular(80),

                        child: selectedImage==null
                            ? GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: profile==null
                                ? Image.asset(
                              "images/boy.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              profile!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            )
                        )

                            : Image.file(
                          selectedImage!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),

                      ),
                    ),
                  ),
                ),

                Padding(

                  padding: EdgeInsets.only(top: 70),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'
                        ),
                      ),
                    ],
                  ),
                ),

              ],

            ),

            SizedBox(height: 20,),

            Container(

              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Material(

                elevation: 5,
                borderRadius: BorderRadius.circular(10),

                child: Container(

                  padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(

                    children: [

                      Icon(
                        Icons.person,
                        color: Colors.black,
                      ),

                      SizedBox(width: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Name",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,

                            ),
                          ),


                          Text(
                            name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,

                            ),
                          ),

                        ],

                      )

                    ],

                  ),

                ),

              ),

            ),

            SizedBox(height: 20,),

            Container(

              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Material(

                elevation: 5,
                borderRadius: BorderRadius.circular(10),

                child: Container(

                  padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(

                    children: [

                      Icon(
                        Icons.email,
                        color: Colors.black,
                      ),

                      SizedBox(width: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,

                            ),
                          ),

                          Text(
                            email!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,

                            ),
                          ),

                        ],

                      )

                    ],

                  ),

                ),

              ),

            ),

            SizedBox(height: 20,),

            Container(

              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Material(

                elevation: 5,
                borderRadius: BorderRadius.circular(10),

                child: Container(

                  padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(

                    children: [

                      Icon(
                        Icons.description,
                        color: Colors.black,
                      ),

                      SizedBox(width: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Terms and Condition",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,

                            ),
                          ),

                        ],

                      )

                    ],

                  ),

                ),

              ),

            ),

            SizedBox(height: 20,),

            // Admin Login pannel .......
            GestureDetector(

              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin())),

              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Material(

                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),

                  child: Container(

                    padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(

                      children: [

                        Icon(
                          Icons.person,
                          color: Colors.black,
                        ),

                        SizedBox(width: 20,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Seller login",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,

                              ),
                            ),

                          ],

                        )

                      ],

                    ),

                  ),

                ),

              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(

              onTap: () {

                showDialog(
                  context: context,
                  builder: (BuildContext context) {

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),

                      child: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Are You Sure?',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Do you want to delete the account ?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  child: Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {

                                    AuthMethods().deleteUser();// Call the logout function
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LogIn())); // Close the dialog
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.lightGreen,
                                        content: Text(
                                          "Account Deleted !",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        )));

                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );

              },

              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Material(

                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),

                  child: Container(

                    padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(

                      children: [

                        Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),

                        SizedBox(width: 20,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Delete Account",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,

                              ),
                            ),

                          ],

                        )

                      ],

                    ),

                  ),

                ),

              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(

              onTap: () {

                showDialog(
                  context: context,
                  builder: (BuildContext context) {

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),

                      child: Container(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Are You Sure?',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Do you want to logout',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  child: Text(
                                    'No',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {

                                    AuthMethods().SignOut(); // Call the logout function
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LogIn())); // Close the dialog
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        backgroundColor: Colors.lightGreen,
                                        content: Text(
                                          "Logged out sucessfully !",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        )));

                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );

              },

              child: Container(

                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Material(

                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),

                  child: Container(

                    padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(

                      children: [

                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),

                        SizedBox(width: 20,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "LogOut",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,

                              ),
                            ),

                          ],

                        )

                      ],

                    ),

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