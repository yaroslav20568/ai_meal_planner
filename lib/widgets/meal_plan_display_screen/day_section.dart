import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/meal_plan_display_screen/meal_type_section.dart';

class DaySection extends StatelessWidget {
  final int day;
  final List<Meal> meals;

  const DaySection({super.key, required this.day, required this.meals});

  @override
  Widget build(BuildContext context) {
    final mealsByType = <String, List<Meal>>{};
    for (var meal in meals) {
      mealsByType.putIfAbsent(meal.mealType, () => []).add(meal);
    }

    final dayCalories = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.calories,
    );
    final dayProteins = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.proteins,
    );
    final dayCarbs = meals.fold<double>(0, (sum, meal) => sum + meal.carbs);
    final dayFats = meals.fold<double>(0, (sum, meal) => sum + meal.fats);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          'Day $day',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${meals.length} meals'),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${dayCalories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Text('P: ${dayProteins.toStringAsFixed(0)}g'),
                const SizedBox(width: 8),
                Text('C: ${dayCarbs.toStringAsFixed(0)}g'),
                const SizedBox(width: 8),
                Text('F: ${dayFats.toStringAsFixed(0)}g'),
              ],
            ),
          ],
        ),
        children: [
          ...mealsByType.entries.map((entry) {
            final mealType = entry.key;
            final typeMeals = entry.value;
            return MealTypeSection(mealType: mealType, meals: typeMeals);
          }),
        ],
      ),
    );
  }
}
