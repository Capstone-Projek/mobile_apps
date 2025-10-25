import 'package:flutter/material.dart';

class IngredientItem extends StatelessWidget {
  final String name;
  final String? qty;

  const IngredientItem({
    super.key,
    required this.name,
    this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          if (qty != null)
            Text(
              qty!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
