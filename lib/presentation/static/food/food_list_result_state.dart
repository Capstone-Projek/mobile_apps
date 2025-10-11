import 'package:mobile_apps/data/models/main/food/food_model.dart';

sealed class FoodListResultState {}

class FoodListResultNoneState extends FoodListResultState {}

class FoodListResultLoadingState extends FoodListResultState {}

class FoodListResultErrorState extends FoodListResultState {
  final String error;

  FoodListResultErrorState({required this.error});
}

class FoodListResultLoadedState extends FoodListResultState {
  final List<FoodModel> data;

  FoodListResultLoadedState({required this.data});
}
