import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:food_delivery_app/service/database.dart';
// import 'package:food_delivery_app/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_eats_app/pages/bottom_nav/bottom_nav.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:random_string/random_string.dart';

import '../widget/widget_support.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {

  final List<String> items = ['Ice-cream', 'Burger', 'Salad', 'Pizza'] ;
  String? value ;
  final ImagePicker _picker = ImagePicker() ;
  File? selectedImage ;

  TextEditingController nameController = TextEditingController() ;
  TextEditingController priceController = TextEditingController() ;
  TextEditingController detailController = TextEditingController() ;

  // For Feteching the image from the gallery ....
  Future getImage() async {

    try {

      var image = await _picker.pickImage(source: ImageSource.gallery) ;

      selectedImage = File(image!.path) ;

      setState(() {

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

    if(selectedImage!=null && nameController.text!="" && priceController!="" && detailController!="") {

      String addId = randomAlphaNumeric(10) ;

      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId) ;

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!) ;

      var downloadUrl = await(await task).ref.getDownloadURL() ;

      Map<String, dynamic> addItem = {

        "Image" : downloadUrl,
        "Name" : nameController.text,
        "Price" : priceController.text,
        "Detail" : detailController.text,

      };

      await DatabaseMethods().addFoodItem(addItem, value!).then((value) async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Food Item has been added Successfully !",
            style: TextStyle(fontSize: 20),
          ),
        ));
      });

      await Future.delayed(Duration(milliseconds: 1500));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );

    }

    else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.redAccent,
          content: Text(
            "Please enter the details !",
            style: TextStyle(fontSize: 20),
          )));

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        leading: GestureDetector(

          onTap: () => Navigator.pop(context) ,
          child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
          ),
        ),

        centerTitle: true,
        title: Text('Add Item', style: AppWidget.HeadlineTextFieldStyle(),),

      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Upload the Item Picture", style: AppWidget.semiBoldFieldStyle(),),

              SizedBox(height: 20,),


              selectedImage==null ? GestureDetector(

                onTap: () {
                  getImage() ;
                },

                child: Center(
                  child: Material(

                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),

                    child: Container(

                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Icon(Icons.camera_alt_outlined, color: Colors.black,),

                    ),
                  ),

                ),
              ) : Center(
                child: Material(

                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),

                  child: Container(

                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(

                        selectedImage!,
                        fit: BoxFit.cover,

                      ),
                    ),

                  ),
                ),
              ),

              SizedBox(height: 30,),

              Text("Items Name", style: AppWidget.semiBoldFieldStyle(),),

              SizedBox(height: 10,),

              Container(

                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "eg : Ice-cream, Burger, Salad, Pizza",
                    hintStyle: TextStyle(
                      color: Colors.black38,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    )
                  ),
                ),

              ),

              SizedBox(height: 30,),

              Text("Items Price", style: AppWidget.semiBoldFieldStyle(),),

              SizedBox(height: 10,),

              Container(

                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Item Price",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      )
                  ),
                ),

              ),

              SizedBox(height: 30,),

              Text("Items Details", style: AppWidget.semiBoldFieldStyle(),),

              SizedBox(height: 10,),

              Container(

                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextField(
                  maxLines: 6,
                  controller: detailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Item Details",
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      )
                  ),
                ),

              ),

              SizedBox(height: 20,),

              Text("Select Category", style: AppWidget.semiBoldFieldStyle(),),

              SizedBox(height: 20,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String> (
                    items: items.map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 18, color: Colors.black),)
                    )).toList(),

                    onChanged: ((value) =>  setState(() {

                      this.value = value ;

                    })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    value: value,
                  ),
                ),

              ),

              SizedBox(height: 30,),

              GestureDetector(

                onTap: () {

                  uploadItem() ;

                },

                child: Center(
                  child: Material(

                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),

                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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


    );
  }
}
