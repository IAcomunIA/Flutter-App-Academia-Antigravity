import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

enum SpaceButtonVariant { primary, secondary, danger }

class SpaceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final SpaceButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const SpaceButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SpaceButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color btnColor;
    switch (variant) {
      case SpaceButtonVariant.primary: btnColor = AppColors.cyan; break;
      case SpaceButtonVariant.secondary: btnColor = AppColors.purple; break;
      case SpaceButtonVariant.danger: btnColor = AppColors.error; break;
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        shadowColor: btnColor.withOpacity(0.5),
      ),
      child: isLoading 
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
    );
  }
}