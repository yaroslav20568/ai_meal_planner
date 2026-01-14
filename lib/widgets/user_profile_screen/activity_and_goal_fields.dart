import 'package:flutter/material.dart';

class ActivityAndGoalFields extends StatelessWidget {
  final String activityLevel;
  final String goal;
  final ValueChanged<String> onActivityLevelChanged;
  final ValueChanged<String> onGoalChanged;

  const ActivityAndGoalFields({
    super.key,
    required this.activityLevel,
    required this.goal,
    required this.onActivityLevelChanged,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: activityLevel,
          decoration: const InputDecoration(
            labelText: 'Activity Level',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Sedentary', child: Text('Sedentary')),
            DropdownMenuItem(value: 'Light', child: Text('Light')),
            DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
            DropdownMenuItem(value: 'Active', child: Text('Active')),
            DropdownMenuItem(value: 'Very Active', child: Text('Very Active')),
          ],
          onChanged: (value) => onActivityLevelChanged(value!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: goal,
          decoration: const InputDecoration(
            labelText: 'Goal',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Weight Loss', child: Text('Weight Loss')),
            DropdownMenuItem(
              value: 'Maintenance',
              child: Text('Maintain Weight'),
            ),
            DropdownMenuItem(value: 'Weight Gain', child: Text('Weight Gain')),
          ],
          onChanged: (value) => onGoalChanged(value!),
        ),
      ],
    );
  }
}
