import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String name;
  final String comment;
  const CommentCard({super.key, required this.name, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(comment, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
