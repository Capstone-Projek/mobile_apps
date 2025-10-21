import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_list_by_food_id_result_state.dart';

class FoodPlaceListByFoodIdProvider extends ChangeNotifier {
  final ApiService _apiService;

  FoodPlaceListByFoodIdProvider(this._apiService);

  FoodPlaceListByFoodIdResultState _resulState = FoodPlaceListByFoodIdNoneState();
  
  FoodPlaceListByFoodIdResultState get resultState => _resulState;

  Future<void> fetchFoodPlaceListByFoodId(int foodId) async {
    try {
      _resulState = FoodPlaceListByFoodIdLoadingState();
      notifyListeners();

      final result = await _apiService.getAllFoodPlaceByFoodId(foodId);

      final limitedResult = result.length > 4 ? result.sublist(0, 4) : result;

      if (limitedResult.isNotEmpty) {
        _resulState = FoodPlaceListByFoodIdLoadedState(data: limitedResult);
      } else {
        _resulState = FoodPlaceListByFoodIdErrorState(error: "Data Kosong");
      }
    } catch (e) {
      _resulState = FoodPlaceListByFoodIdErrorState(error: e.toString());
    }
    notifyListeners();
  }
}