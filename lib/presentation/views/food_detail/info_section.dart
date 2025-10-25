import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String category;
  final String timeCook;
  final String serving;

  const InfoSection({
    super.key,
    required this.category,
    required this.timeCook,
    required this.serving,
  });

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF26599A)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.category, category),
          _buildInfoItem(Icons.timer, timeCook),
          _buildInfoItem(Icons.person, serving),
        ],
      ),
    );
  }
}
