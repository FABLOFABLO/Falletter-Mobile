import 'package:flutter/material.dart';

class FlexibleIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Gradient? gradient;
  final Color? color;
  final double fill;

  const FlexibleIcon({
    super.key,
    required this.icon,
    this.size,
    this.gradient,
    this.color,
    this.fill = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) => gradient!.createShader(bounds),
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
          fill: fill,
        ),
      );
    } else {
      return Icon(
        icon,
        size: size,
        color: color,
        fill: fill,
      );
    }
  }
}