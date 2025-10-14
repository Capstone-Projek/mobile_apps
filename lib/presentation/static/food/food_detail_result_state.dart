import 'package:mobile_apps/data/models/main/food/food_model.dart';

sealed class FoodDetailResultState {}

class FoodDetailNoneState extends FoodDetailResultState {}

class FoodDetailLoadingState extends FoodDetailResultState {}

class FoodDetailErrorState extends FoodDetailResultState {
  final String error;

  FoodDetailErrorState({required this.error});
}

class FoodDetailLoadedState extends FoodDetailResultState {
  final FoodModel data;

  FoodDetailLoadedState({required this.data});
}
