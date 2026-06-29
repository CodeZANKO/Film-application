import 'package:flutter/material.dart';
import 'package:film_app/core/theme/app_theme.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),
        Positioned(
          top: -100,
          right: -100,
          child: _Blob(
            color: AppColors.primary.withValues(alpha: 0.3),
            size: 400,
          ),
        ),
        Positioned(
          bottom: 100,
          left: -150,
          child: _Blob(
            color: AppColors.accent.withValues(alpha: 0.2),
            size: 500,
          ),
        ),
        Positioned(
          top: 300,
          left: 50,
          child: _Blob(
            color: Colors.blueAccent.withValues(alpha: 0.15),
            size: 300,
          ),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

