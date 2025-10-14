import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food/food_detail_result_state.dart';

class FoodDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  FoodDetailProvider(this._apiService);

  FoodDetailResultState _resultState = FoodDetailNoneState();
  FoodDetailResultState get resultState => _resultState;


  Future<void> fetchFoodById(int id) async {
    try {
      _resultState = FoodDetailLoadingState();
      notifyListeners();

      final result = await _apiService.getFoodById(id);

      _resultState = FoodDetailLoadedState(data: result);
    } catch (e) {
      _resultState = FoodDetailErrorState(error: e.toString());
    }

    notifyListeners();
  }
}