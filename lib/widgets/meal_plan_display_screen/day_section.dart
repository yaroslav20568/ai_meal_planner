import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/meal_plan_display_screen/meal_type_section.dart';

class DaySection extends StatelessWidget {
  final int day;
  final List<Meal> meals;

  const DaySection({super.key, required this.day, required this.meals});

  Map<String, List<Meal>> _groupMealsByType() {
    final mealsByType = <String, List<Meal>>{};
    for (var meal in meals) {
      mealsByType.putIfAbsent(meal.mealType, () => []).add(meal);
    }
    return mealsByType;
  }

  double _calculateTotalCalories() {
    return meals.fold<double>(0, (sum, meal) => sum + meal.calories);
  }

  double _calculateTotalProteins() {
    return meals.fold<double>(0, (sum, meal) => sum + meal.proteins);
  }

  double _calculateTotalCarbs() {
    return meals.fold<double>(0, (sum, meal) => sum + meal.carbs);
  }

  double _calculateTotalFats() {
    return meals.fold<double>(0, (sum, meal) => sum + meal.fats);
  }

  Widget _buildMealTypeSection(MapEntry<String, List<Meal>> entry) {
    final mealType = entry.key;
    final typeMeals = entry.value;
    return MealTypeSection(mealType: mealType, meals: typeMeals);
  }

  @override
  Widget build(BuildContext context) {
    final mealsByType = _groupMealsByType();
    final dayCalories = _calculateTotalCalories();
    final dayProteins = _calculateTotalProteins();
    final dayCarbs = _calculateTotalCarbs();
    final dayFats = _calculateTotalFats();

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
          const SizedBox(height: 8),
          ...mealsByType.entries.map(_buildMealTypeSection),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
