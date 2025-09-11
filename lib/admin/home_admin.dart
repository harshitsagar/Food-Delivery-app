import 'package:flutter/material.dart';
import 'package:quick_eats_app/admin/add_food.dart';
import 'package:quick_eats_app/pages/bottom_nav/bottom_nav.dart';
import 'package:quick_eats_app/widget/widget_support.dart';
// import 'package:food_delivery_app/admin/add_food.dart';
// import 'package:food_delivery_app/widget/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Home",
          style: AppWidget.HeadlineTextFieldStyle(),
        ),
        centerTitle: true,
      ),

      body: Container(

        margin: EdgeInsets.only(top: 50, left: 20, right: 20),

        child: Column(

          children: [

            GestureDetector(

              onTap: () {

                Navigator.push(context, MaterialPageRoute(builder: (context) => AddFood()));

              },

              child: Material(

                elevation: 10,
                borderRadius: BorderRadius.circular(10),

                child: Center(

                  child: Container(

                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Row(

                      children: [

                        Padding(

                          padding: EdgeInsets.all(6),

                          child: Image.asset(
                            "images/food.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),

                        ),

                        SizedBox(width: 30,),

                        Text(
                          "Add Food Items",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),

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
