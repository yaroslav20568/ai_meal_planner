import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanGenerationScreen extends StatelessWidget {
  final UserProfile userProfile;

  const MealPlanGenerationScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Generate Meal Plan',
      showSignOutButton: true,
      child: MealPlanGenerationForm(
        userProfile: userProfile,
        onMealPlanGenerated: (mealPlanId) {
          Navigator.of(
            context,
          ).pushReplacementNamed('/meal-plan', arguments: mealPlanId);
        },
      ),
    );
  }
}
