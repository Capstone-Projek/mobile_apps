import 'package:mobile_apps/data/models/food_place/food_place_list_response_model.dart';

sealed class FoodPlaceListByFoodIdResultState {}

class FoodPlaceListByFoodIdNoneState extends FoodPlaceListByFoodIdResultState {}

class FoodPlaceListByFoodIdLoadingState extends FoodPlaceListByFoodIdResultState {}

class FoodPlaceListByFoodIdErrorState extends FoodPlaceListByFoodIdResultState {
  final String error;

  FoodPlaceListByFoodIdErrorState({required this.error});
}

class FoodPlaceListByFoodIdLoadedState extends FoodPlaceListByFoodIdResultState {
  final List<FoodPlaceListResponseModel> data;

  FoodPlaceListByFoodIdLoadedState({required this.data});
}
