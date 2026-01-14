import 'package:flutter/material.dart';

class DietaryRestrictionsSection extends StatelessWidget {
  final List<String> availableRestrictions;
  final List<String> selectedRestrictions;
  final ValueChanged<String> onRestrictionToggled;

  const DietaryRestrictionsSection({
    super.key,
    required this.availableRestrictions,
    required this.selectedRestrictions,
    required this.onRestrictionToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dietary Restrictions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableRestrictions.map((restriction) {
            final isSelected = selectedRestrictions.contains(restriction);
            return FilterChip(
              label: Text(restriction),
              selected: isSelected,
              onSelected: (_) => onRestrictionToggled(restriction),
            );
          }).toList(),
        ),
      ],
    );
  }
}
