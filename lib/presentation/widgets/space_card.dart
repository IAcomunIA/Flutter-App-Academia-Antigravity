import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SpaceCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double? padding;

  const SpaceCard({super.key, required this.child, this.borderColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: (borderColor ?? AppColors.cyan).withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: child,
    );
  }
}