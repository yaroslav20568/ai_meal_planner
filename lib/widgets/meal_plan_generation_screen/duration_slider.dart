import 'package:flutter/material.dart';

class DurationSlider extends StatelessWidget {
  final int durationDays;
  final ValueChanged<int> onDurationChanged;

  const DurationSlider({
    super.key,
    required this.durationDays,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan duration (days)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: durationDays.toDouble(),
                min: 1,
                max: 14,
                divisions: 13,
                label: '$durationDays days',
                onChanged: (value) => onDurationChanged(value.toInt()),
              ),
            ),
            Text('$durationDays', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}
