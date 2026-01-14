import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const ScreenLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.surfaceColor,
      ),
      body: SafeArea(child: child),
    );
  }
}
