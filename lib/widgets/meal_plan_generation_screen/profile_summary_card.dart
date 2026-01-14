import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';

class ProfileSummaryCard extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileSummaryCard({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile: ${userProfile.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Goal: ${userProfile.goal}'),
            Text('Target calories: ${userProfile.dailyCalories} kcal/day'),
            Text('BMI: ${userProfile.bmi.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}
