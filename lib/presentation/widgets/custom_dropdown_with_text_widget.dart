import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownWithTextWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdownWithTextWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          hint: Text(
            hintText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: Theme.of(context).textTheme.bodyLarge),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
