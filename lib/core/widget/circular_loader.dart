import 'dart:math';
import 'package:flutter/material.dart';

class CircleDotLoader extends StatefulWidget {
  final Color color;
  final double size;

  const CircleDotLoader({
    super.key,
    required this.color,
    this.size = 50.0,
  });

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
      duration: const Duration(milliseconds: 1000),
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
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: List.generate(8, (index) {
            final double angle = index * (pi / 4);
            return Positioned.fill(
              child: Transform.rotate(
                angle: angle,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double t = (_controller.value - (index * 0.125));
                      if (t < 0) t += 1.0;

                      // This creates a fading effect as it moves around
                      double opacity = 1.0 - t;
                      opacity = opacity.clamp(0.2, 1.0);

                      // Also scale a bit for better effect
                      double scale = 1.0 - (t * 0.3);
                      scale = scale.clamp(0.7, 1.0);

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: widget.size * 0.25,
                          height: widget.size * 0.25,
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(opacity),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}