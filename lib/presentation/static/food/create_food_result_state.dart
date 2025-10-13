import 'package:mobile_apps/data/models/main/food/food_model.dart';

sealed class CreateFoodResultState {}

class CreateFoodResultNoneState extends CreateFoodResultState {}

class CreateFoodResultLoadingState extends CreateFoodResultState {}

class CreateFoodResultErrorState extends CreateFoodResultState {
  final String error;

  CreateFoodResultErrorState({required this.error});
}

class CreateFoodResultLoadedState extends CreateFoodResultState {
  final List<FoodModel> data;

  CreateFoodResultLoadedState({required this.data});
}
