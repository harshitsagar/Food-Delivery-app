import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Details extends StatefulWidget {

  String image , name , detail , price  ;

  Details({
    required this.detail,
    required this.image,
    required this.name,
    required this.price
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  int a  = 1 ;
  double total = 0 ;
  String? id ;

  getTheSharedPref() async {

    id = await SharedPreferenceHelper().getUserId() ;
    print("***********Id is " + id!);
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
    total = double.parse(widget.price) ;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        margin: EdgeInsets.only(top: 50, left: 20, right: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            GestureDetector(

              onTap: () {

                Navigator.pop(context) ;
                
              },

              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10,),

            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                widget.image,
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),

            SizedBox(height: 15,),

            Row(
              children: [

                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(widget.name, style: AppWidget.semiBoldFieldStyle(),),

                    ],
                  ),
                ),

                Spacer(flex: 2),

                GestureDetector(

                  onTap: () {

                    if(a>1) {
                      --a ;
                      total = total - double.parse(widget.price);
                    }

                    setState(() {

                    });

                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Icon(Icons.remove, color: Colors.white,),

                  ),
                ),

                SizedBox(width: 20,),

                Text(a.toString() , style: AppWidget.semiBoldFieldStyle(),),

                SizedBox(width: 20,),

                GestureDetector(

                  onTap: () {

                    ++a ;

                    total = total + double.parse(widget.price);

                    setState(() {

                    });

                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Icon(Icons.add, color: Colors.white,),

                  ),
                ),

              ],

            ),

            SizedBox(height: 20,),
            
            Text(
              widget.detail,
              style: AppWidget.LightTextFieldStyle(),
              maxLines: 4,
            ),

            SizedBox(height: 30,),

            Row(
              children: [

                Text(
                  "Delivery Time",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(width: 25,),

                Icon(
                  Icons.alarm, 
                  color: Colors.black54,
                ),

                SizedBox(width: 5,),
                
                Text(
                  "30 min",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
                
                
              ],
            ),

            Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldFieldStyle(),
                      ),

                      Text(
                        total == total.toInt()
                            ? "\$" + total.toInt().toString()
                            : "\$" + total.toStringAsFixed(2),
                        style: AppWidget.HeadlineTextFieldStyle(),
                      ),

                    ],
                  ),

                  GestureDetector(

                    onTap: () async {

                      Map<String, dynamic> addFoodtoCart = {

                        "Name" : widget.name,
                        "Quantity" : a.toString(),
                        "Total" : total == total.toInt()
                                  ? "\$" + total.toInt().toString()
                                  : "\$" + total.toStringAsFixed(2),
                        "Image" : widget.image,

                      };

                      await DatabaseMethods().addFoodToCart(addFoodtoCart, id!);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 1500),
                          content: Text(
                            "Food Added to Cart !",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )));

                    },

                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),

                          SizedBox(width: 30,),

                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 10,),

                        ],

                      ),
                    ),
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
