import 'package:mobile_apps/data/models/main/resto/resto_food_model.dart';

sealed class FoodPlaceDetailResultState {}

class FoodPlaceDetailNoneState extends FoodPlaceDetailResultState {}

class FoodPlaceDetailLoadingState extends FoodPlaceDetailResultState {}

class FoodPlaceDetailErrorState extends FoodPlaceDetailResultState {
  final String error;

  FoodPlaceDetailErrorState({required this.error});
}

class FoodPlaceDetailLoadedState extends FoodPlaceDetailResultState {
  final RestoPlaceModel data;

  FoodPlaceDetailLoadedState({required this.data});
}
