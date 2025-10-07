import 'package:flutter/material.dart';
import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class RecommendationFoodWidget extends StatelessWidget {
  final FoodListResponseModel recomendationFoodModel;
  final Function() onTap;
  const RecommendationFoodWidget({
    super.key,
    required this.recomendationFoodModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = recomendationFoodModel.images!.isNotEmpty;
    final imageUrl = hasImage
        ? recomendationFoodModel.images!.first.imageUrl
        : null;

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
                  child: hasImage
                      ? Image.network(
                          imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                recomendationFoodModel.foodName,
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
                  recomendationFoodModel.desc,
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
