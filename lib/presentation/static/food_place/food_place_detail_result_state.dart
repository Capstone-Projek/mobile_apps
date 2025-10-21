import 'package:mobile_apps/data/models/food_place/food_place_detail_response_model.dart';

sealed class FoodPlaceDetailResultState {}

class FoodPlaceDetailNoneState extends FoodPlaceDetailResultState {}

class FoodPlaceDetailLoadingState extends FoodPlaceDetailResultState {}

class FoodPlaceDetailErrorState extends FoodPlaceDetailResultState {
  final String error;

  FoodPlaceDetailErrorState({required this.error});
}

class FoodPlaceDetailLoadedState extends FoodPlaceDetailResultState {
  final FoodPlaceDetailResponseModel data;

  FoodPlaceDetailLoadedState({required this.data});
}
