import 'package:flutter/material.dart';
import 'package:quick_eats_app/pages/onBoarding_screen/onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboard screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or your brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 300,),
            // Replace with your app logo
            Image.asset(
              'images/splash_logo.png', // Make sure to add this asset
              height: 180,
              width: 200,
            ),
            const SizedBox(height: 0),
            const Text(
              'Quick Eats',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Match your brand color
                fontFamily: 'Poppins',
                // fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}