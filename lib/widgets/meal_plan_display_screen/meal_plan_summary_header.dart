import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';

class MealPlanSummaryHeader extends StatelessWidget {
  final MealPlan mealPlan;

  const MealPlanSummaryHeader({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.primaryColorLight,
      child: Column(
        children: [
          Text(
            'Plan for ${mealPlan.durationDays} days',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroStat(
                'Calories',
                mealPlan.totalCalories.toStringAsFixed(0),
                'kcal',
              ),
              _buildMacroStat(
                'Proteins',
                mealPlan.totalProteins.toStringAsFixed(0),
                'g',
              ),
              _buildMacroStat(
                'Carbs',
                mealPlan.totalCarbs.toStringAsFixed(0),
                'g',
              ),
              _buildMacroStat(
                'Fats',
                mealPlan.totalFats.toStringAsFixed(0),
                'g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('$label ($unit)', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
