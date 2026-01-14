import 'package:flutter/material.dart';

class SelectableChipsSection extends StatelessWidget {
  final String title;
  final List<String> availableItems;
  final List<String> selectedItems;
  final ValueChanged<String> onItemToggled;

  const SelectableChipsSection({
    super.key,
    required this.title,
    required this.availableItems,
    required this.selectedItems,
    required this.onItemToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableItems.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onItemToggled(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
