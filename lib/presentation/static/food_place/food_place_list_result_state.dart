import 'package:mobile_apps/data/models/food_place/food_place_list_response_model.dart';

sealed class FoodPlaceListResultState {}

class FoodPlaceListNoneState extends FoodPlaceListResultState {}

class FoodPlaceListLoadingState extends FoodPlaceListResultState {}

class FoodPlaceListErrorState extends FoodPlaceListResultState {
  final String error;

  FoodPlaceListErrorState({required this.error});
}

class FoodPlaceListLoadedState extends FoodPlaceListResultState {
  final List<FoodPlaceListResponseModel> data;

  FoodPlaceListLoadedState({required this.data});
}
