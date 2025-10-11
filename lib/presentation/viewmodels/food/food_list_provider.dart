import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food/food_list_result_state.dart';

class FoodListProvider extends ChangeNotifier {
  final ApiService _apiService;

  FoodListProvider(this._apiService);

  FoodListResultState _resultState = FoodListResultNoneState();

  FoodListResultState get resultState => _resultState;

  Future<void> getFoodList() async {
    try {
      _resultState = FoodListResultLoadingState();
      notifyListeners();

      final result = await _apiService.getFoods();
      _resultState = FoodListResultLoadedState(data: result);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _resultState = FoodListResultErrorState(error: "Failed to get food list");
      notifyListeners();
    }
  }
}
