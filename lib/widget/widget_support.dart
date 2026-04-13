import 'package:flutter/material.dart';

class AppWidget {

  static TextStyle boldTextFieldStyle() {

    return const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );

  }

  static TextStyle HeadlineTextFieldStyle() {

    return const TextStyle(
      color: Colors.black,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );

  }

  static TextStyle LightTextFieldStyle() {

    return const TextStyle(
      color: Colors.black54,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );

  }

  static TextStyle semiBoldFieldStyle() {

    return const TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );

  }


}