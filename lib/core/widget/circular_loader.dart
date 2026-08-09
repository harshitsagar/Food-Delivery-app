import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleDotLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CircleDotLoader({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size.r,
        width: size.r,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 3.w,
        ),
      ),
    );
  }
}
