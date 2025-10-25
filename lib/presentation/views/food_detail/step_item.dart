import 'package:flutter/material.dart';

class StepItem extends StatelessWidget {
  final String? number;
  final String step;

  const StepItem({
    super.key,
    this.number,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (number != null)
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                number!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          if (number != null) const SizedBox(width: 12),
          Expanded(child: Text(step)),
        ],
      ),
    );
  }
}
