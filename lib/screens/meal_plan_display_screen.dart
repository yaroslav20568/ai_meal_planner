import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanDisplayScreen extends StatelessWidget {
  final MealPlan mealPlan;

  const MealPlanDisplayScreen({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    final mealsByDay = <int, List<Meal>>{};
    for (var meal in mealPlan.meals) {
      mealsByDay.putIfAbsent(meal.day, () => []).add(meal);
    }

    final sortedDays = mealsByDay.keys.toList()..sort();

    return ScreenLayout(
      title: 'Meal Plan',
      showSignOutButton: true,
      child: Column(
        children: [
          MealPlanSummaryHeader(mealPlan: mealPlan),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDays.length,
              itemBuilder: (context, index) {
                final day = sortedDays[index];
                final meals = mealsByDay[day]!;
                return DaySection(day: day, meals: meals);
              },
            ),
          ),
        ],
      ),
    );
  }
}
