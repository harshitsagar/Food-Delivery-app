import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleDotLoader extends StatefulWidget {
  final Color color;
  final double size;

  const CircleDotLoader({super.key, required this.color, required this.size});

  @override
  State<CircleDotLoader> createState() => _CircleDotLoaderState();
}

class _CircleDotLoaderState extends State<CircleDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size.r,
        height: widget.size.r,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _CircleDotPainter(
                color: widget.color,
                rotationValue: _controller.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleDotPainter extends CustomPainter {
  final Color color;
  final double rotationValue;

  _CircleDotPainter({required this.color, required this.rotationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    const int dotCount = 8;
    final double dotRadius = size.width / 10;

    for (int i = 0; i < dotCount; i++) {
      final double angle = (i * 2 * pi / dotCount) + (rotationValue * 2 * pi);
      final double opacity = (1.0 - (i / dotCount)).clamp(0.1, 1.0);
      
      final Offset dotOffset = Offset(
        center.dx + radius * 0.8 * cos(angle),
        center.dy + radius * 0.8 * sin(angle),
      );

      final Paint paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotOffset, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircleDotPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
