import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';

enum ButtonVariant { primary }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final ButtonVariant variant;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.padding,
    this.fontSize,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.surfaceColor,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        disabledBackgroundColor: AppColors.textSecondary,
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loadingText ?? 'Loading...',
                  style: TextStyle(fontSize: fontSize ?? 16),
                ),
              ],
            )
          : Text(text, style: TextStyle(fontSize: fontSize ?? 16)),
    );
  }
}
