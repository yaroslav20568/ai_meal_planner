import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;

  const ErrorMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.errorColorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.errorColor),
      ),
      child: Text(message, style: const TextStyle(color: AppColors.errorColor)),
    );
  }
}
