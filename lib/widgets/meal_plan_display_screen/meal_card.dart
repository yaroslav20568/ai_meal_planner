import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${meal.calories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (meal.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                meal.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMacroChip('P: ${meal.proteins.toStringAsFixed(1)}g'),
                const SizedBox(width: 8),
                _buildMacroChip('C: ${meal.carbs.toStringAsFixed(1)}g'),
                const SizedBox(width: 8),
                _buildMacroChip('F: ${meal.fats.toStringAsFixed(1)}g'),
              ],
            ),
            if (meal.ingredients.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: meal.ingredients
                    .map(
                      (ingredient) => Chip(
                        label: Text(ingredient),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (meal.recipe != null && meal.recipe!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ExpansionTile(
                title: const Text('Recipe'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(meal.recipe!),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColorLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
