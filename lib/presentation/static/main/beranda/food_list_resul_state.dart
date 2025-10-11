import 'package:mobile_apps/data/models/main/home/food_list_response_models.dart';

sealed class FoodListResulState {}

class FoodListNoneStae extends FoodListResulState {}

class FoodListLoadingState extends FoodListResulState {}

class FoodListErrorState extends FoodListResulState {
  final String error;

  FoodListErrorState({required this.error});
}

class FoodListLoadedState extends FoodListResulState {
  final List<FoodListResponseModel> data;

  FoodListLoadedState({required this.data});
}
