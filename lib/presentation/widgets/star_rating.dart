import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StarRating extends StatelessWidget {
  final int stars; // 0 to 3

  const StarRating({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: index < stars ? AppColors.starColor : AppColors.textMuted,
          size: 32,
        );
      }),
    );
  }
}