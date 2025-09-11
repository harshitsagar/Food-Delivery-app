import 'package:flutter/material.dart';
import 'package:quick_eats_app/pages/auth_pages/login.dart';
import 'package:quick_eats_app/widget/content_model.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        
        children: [
          
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  
                  return Padding(
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Column(
                      children: [
                        
                        Image.asset(
                          contents[i].image,
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        
                        SizedBox(
                          height: 40,
                        ),
                        
                        Text(
                          contents[i].title,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        
                        SizedBox(
                          height: 20,
                        ),
                        
                        Text(
                          contents[i].description,
                          style: AppWidget.LightTextFieldStyle(),
                        ),
                        
                      ],
                    ),
                  );
                }),
          ),
          
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildDot(index, context)),
            ),
          ),
          
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIn(),
                  ),
                );
              }

              _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn);
            },

            //change here ......
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      // Colors.blue,
                      Colors.orange,
                      Colors.red
                    ]),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              margin: EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length - 1 ? "Start" : "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 18 : 7,
      margin: EdgeInsets.only(
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
