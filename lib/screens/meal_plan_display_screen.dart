import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanDisplayScreen extends StatelessWidget {
  final MealPlan mealPlan;

  const MealPlanDisplayScreen({super.key, required this.mealPlan});

  Map<int, List<Meal>> _groupMealsByDay() {
    final mealsByDay = <int, List<Meal>>{};
    for (var meal in mealPlan.meals) {
      mealsByDay.putIfAbsent(meal.day, () => []).add(meal);
    }
    return mealsByDay;
  }

  List<int> _getSortedDays(Map<int, List<Meal>> mealsByDay) {
    return mealsByDay.keys.toList()..sort();
  }

  Widget _buildDaySection(int day, Map<int, List<Meal>> mealsByDay) {
    final meals = mealsByDay[day]!;
    return DaySection(day: day, meals: meals);
  }

  @override
  Widget build(BuildContext context) {
    final mealsByDay = _groupMealsByDay();
    final sortedDays = _getSortedDays(mealsByDay);

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
              itemBuilder: (context, index) =>
                  _buildDaySection(sortedDays[index], mealsByDay),
            ),
          ),
        ],
      ),
    );
  }
}
