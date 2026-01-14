import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanGenerationScreen extends StatelessWidget {
  final UserProfile userProfile;

  const MealPlanGenerationScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Meal Plan'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.surfaceColor,
      ),
      body: SafeArea(
        child: MealPlanGenerationForm(
          userProfile: userProfile,
          onMealPlanGenerated: (mealPlan) {
            Navigator.of(
              context,
            ).pushReplacementNamed('/meal-plan', arguments: mealPlan);
          },
        ),
      ),
    );
  }
}
