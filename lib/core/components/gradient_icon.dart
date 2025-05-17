import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Gradient gradient;
  final double fill;

  const GradientIcon({
    super.key,
    required this.icon,
    this.size,
    required this.gradient,
    this.fill = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
        fill: fill,
      ),
    );
  }
}