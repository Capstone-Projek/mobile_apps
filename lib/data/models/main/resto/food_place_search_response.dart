
import 'package:mobile_apps/data/models/main/resto/resto_food_model.dart';

class FoodPlaceSearchResponse {
  final String foodName;
  final List<RestoPlaceModel> results;

  FoodPlaceSearchResponse({
    required this.foodName,
    required this.results,
  });

  factory FoodPlaceSearchResponse.fromJson(Map<String, dynamic> json) {
    return FoodPlaceSearchResponse(
      foodName: json['food_name'] ?? '',
      results: (json['results'] as List<dynamic>)
          .map((e) => RestoPlaceModel.fromJson(e))
          .toList(),
    );
  }
}
