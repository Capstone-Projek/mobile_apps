import 'package:mobile_apps/data/models/main/food/food_model.dart';

sealed class SearchFoodResultState {}

class SearchFoodResultNoneState extends SearchFoodResultState {}

class SearchFoodResultLoadingState extends SearchFoodResultState {}

class SearchFoodResultErrorState extends SearchFoodResultState {
  final String error;

  SearchFoodResultErrorState({required this.error});
}

class SearchFoodResultLoadedState extends SearchFoodResultState {
  final FoodModel data;

  SearchFoodResultLoadedState({required this.data});
}
