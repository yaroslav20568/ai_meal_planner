import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/meal_plan_display_screen/meal_card.dart';

class MealTypeSection extends StatelessWidget {
  final String mealType;
  final List<Meal> meals;

  const MealTypeSection({
    super.key,
    required this.mealType,
    required this.meals,
  });

  String _getMealTypeName(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
        return 'Snack';
      default:
        return mealType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _getMealTypeName(mealType),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...meals.map((meal) => MealCard(meal: meal)),
        ],
      ),
    );
  }
}
