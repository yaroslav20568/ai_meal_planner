import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';

enum ButtonVariant { primary }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final String? helperText;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final ButtonVariant variant;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.helperText,
    this.padding,
    this.fontSize,
    this.variant = ButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
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
                Text(loadingText ?? 'Loading...'),
              ],
            )
          : Text(text, style: TextStyle(fontSize: fontSize ?? 16)),
    );

    if (helperText != null && isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          button,
          const SizedBox(height: 24),
          Text(
            helperText!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      );
    }

    return button;
  }
}
