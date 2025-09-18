import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_eats_app/pages/details_page/details.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {

  bool icecream = false , pizza = false , burger = false , salad = false ;

  Stream? fooditemStream ;

  ontheload() async {

    fooditemStream = await DatabaseMethods().getFoodItem("Pizza");

    setState(() {

    });

  }

  @override
  void initState() {
    ontheload() ;
    super.initState();
  }

  Widget allItems() {
    
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snaphot) {

          return snaphot.hasData

              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snaphot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    DocumentSnapshot ds = snaphot.data.docs[index] ;

                    return GestureDetector(

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(image: ds["Image"], detail: ds["Detail"], name: ds["Name"], price: ds["Price"])
                          ),
                        );

                      },

                      child: SizedBox(
                        height: 300,
                        width: 220,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: Material(

                            elevation: 6,
                            borderRadius: BorderRadius.circular(20),

                            child: Container(
                              padding: EdgeInsets.all(14),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        ds["Image"],
                                        height: 150,
                                        width: 250,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    const SizedBox(height: 10,),

                                    Text(
                                      ds["Name"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),

                                    const SizedBox(height: 5,),

                                    Text(
                                      ds["Detail"],
                                      style: AppWidget.LightTextFieldStyle(),
                                    ),

                                    const SizedBox(height: 10,),

                                    Text(
                                      "\₹" + ds["Price"],
                                      style: AppWidget.semiBoldFieldStyle(),
                                    ),

                                  ],

                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                  })

              : Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ) ;

        }
    );

  }

  Widget allItemsVertically() {

    return StreamBuilder(

        stream: fooditemStream,
        builder: (context, AsyncSnapshot snaphot) {

          return snaphot.hasData

              ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snaphot.data.docs.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              reverse: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {

                DocumentSnapshot ds = snaphot.data.docs[index] ;

                return GestureDetector(

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(image: ds["Image"], detail: ds["Detail"], name: ds["Name"], price: ds["Price"])
                      ),
                    );

                  },

                  child: Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5 ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(width: 5,),

                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["Image"],
                                  height: 110,
                                  width: 150,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),

                            SizedBox(width: 20,),

                            Column(

                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: Text(
                                    ds["Name"],
                                    style: AppWidget.semiBoldFieldStyle(),
                                  ),
                                ),

                                SizedBox(height: 5,),

                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: Text(
                                    ds["Detail"],
                                    style: AppWidget.LightTextFieldStyle(),
                                  ),
                                ),

                                SizedBox(height: 5,),

                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: Text(
                                    "\₹" + ds["Price"],
                                    style: AppWidget.semiBoldFieldStyle(),
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );

              })

              : Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                  ),
              ) ;
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 20),


          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "Hello Harshit,",
                    style: AppWidget.boldTextFieldStyle(),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),

                ],

              ),

              const SizedBox(height: 20,),

              Text(
                "Delicious Food",
                style: AppWidget.HeadlineTextFieldStyle(),
              ),

              Text(
                "Discover and Get Great Food",
                style: AppWidget.LightTextFieldStyle(),
              ),

              const SizedBox(height: 20,),

              Container(
                  margin: EdgeInsets.only(right: 15),
                  child: showItem()
              ) ,

              const SizedBox(height: 30,),

              Container(

                  height: 350,
                  child: allItems()

              ),

              const SizedBox(height: 30,),

              allItemsVertically(),

            ],

          ),

        ),
      ),

    );
  }

  Widget showItem() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // For ice-cream 🍦 ......
        GestureDetector(
          onTap: () async {

            icecream = true ;
            pizza = false ;
            salad = false ;
            burger = false ;

            fooditemStream = await DatabaseMethods().getFoodItem("Ice-cream");

            setState(() {

            });

          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: icecream? Colors.black : Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // For pizza 🍕 ......
        GestureDetector(
          onTap: () async {

            icecream = false ;
            pizza = true ;
            salad = false ;
            burger = false ;

            fooditemStream = await DatabaseMethods().getFoodItem("Pizza");

            setState(() {

            });

          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: pizza? Colors.black : Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // For salad 🥗 ......
        GestureDetector(
          onTap: () async {

            icecream = false ;
            pizza = false ;
            salad = true ;
            burger = false ;

            fooditemStream = await DatabaseMethods().getFoodItem("Salad");

            setState(() {

            });

          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: salad? Colors.black : Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

        // For burger 🍔 ......
        GestureDetector(
          onTap: () async {

            icecream = false ;
            pizza = false ;
            salad = false ;
            burger = true ;

            fooditemStream = await DatabaseMethods().getFoodItem("Burger");

            setState(() {

            });

          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: burger? Colors.black : Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger? Colors.white : Colors.black,
              ),
            ),
          ),
        ),

      ],
    );

  }



}
