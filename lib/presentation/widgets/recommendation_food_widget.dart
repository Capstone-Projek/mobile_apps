import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/home/recomendation_food_model.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class RecommendationFoodWidget extends StatelessWidget {
  final RecomendationFoodModel recomendationFoodModel;
  final Function() onTap;
  const RecommendationFoodWidget({
    super.key,
    required this.recomendationFoodModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onSecondary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(13),
          height: 201,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: JejakRasaColor.accent.color,
            border: Border.all(
              color: JejakRasaColor.tersier.color,
              strokeAlign: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    recomendationFoodModel.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                recomendationFoodModel.tittle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Expanded(
                flex: 2,
                child: Text(
                  recomendationFoodModel.description,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
