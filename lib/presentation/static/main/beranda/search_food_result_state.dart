import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';

sealed class SearchFoodResultState {}

class SearchFoodNoneState extends SearchFoodResultState {}

class SearchFoodLoadingState extends SearchFoodResultState {}

class SearchFoodErrorState extends SearchFoodResultState {
  final String error;

  SearchFoodErrorState({required this.error});
}

class SearchFoodLoadedState extends SearchFoodResultState {
  final FoodListResponseModel data;

  SearchFoodLoadedState({required this.data});
}
