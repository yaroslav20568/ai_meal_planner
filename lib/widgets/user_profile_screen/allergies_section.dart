import 'package:flutter/material.dart';

class AllergiesSection extends StatelessWidget {
  final List<String> availableAllergies;
  final List<String> selectedAllergies;
  final ValueChanged<String> onAllergyToggled;

  const AllergiesSection({
    super.key,
    required this.availableAllergies,
    required this.selectedAllergies,
    required this.onAllergyToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allergies',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableAllergies.map((allergy) {
            final isSelected = selectedAllergies.contains(allergy);
            return FilterChip(
              label: Text(allergy),
              selected: isSelected,
              onSelected: (_) => onAllergyToggled(allergy),
            );
          }).toList(),
        ),
      ],
    );
  }
}
