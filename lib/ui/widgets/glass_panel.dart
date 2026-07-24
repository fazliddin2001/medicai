import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final double blurRadius;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 16.0,
    this.color,
    this.borderColor,
    this.blurRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
