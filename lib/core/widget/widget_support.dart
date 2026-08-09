import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle HeadlineTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 26.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle LightTextFieldStyle() {
    return TextStyle(
      color: Colors.black54,
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle semiBoldFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }
}
