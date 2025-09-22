import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class RecommendationFoodWidget extends StatelessWidget {
  final double width;
  final String title;
  final String description;
  final String image;

  const RecommendationFoodWidget({
    super.key,
    required this.width,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: JejakRasaColor.accent.color,
        border: Border.all(color: JejakRasaColor.tersier.color, strokeAlign: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        
      ]),
    );
  }
}
