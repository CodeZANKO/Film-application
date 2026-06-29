import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:film_app/core/theme/app_theme.dart';

class MovieShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const MovieShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[800]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

