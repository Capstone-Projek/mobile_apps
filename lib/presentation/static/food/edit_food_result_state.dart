import 'package:mobile_apps/data/models/main/food/edit_food_response.dart';

sealed class EditFoodResultState {}

class EditFoodResultNoneState extends EditFoodResultState {}

class EditFoodResultLoadingState extends EditFoodResultState {}

class EditFoodResultErrorState extends EditFoodResultState {
  final String error;

  EditFoodResultErrorState({required this.error});
}

class EditFoodResultLoadedState extends EditFoodResultState {
  final EditFoodResponse data;

  EditFoodResultLoadedState({required this.data});
}
