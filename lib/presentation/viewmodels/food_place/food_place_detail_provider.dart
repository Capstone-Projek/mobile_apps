import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_detail_result_state.dart';

class FoodPlaceDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  FoodPlaceDetailProvider(this._apiService);

  FoodPlaceDetailResultState _resultState = FoodPlaceDetailNoneState();
  FoodPlaceDetailResultState get resultState => _resultState;

  Future<void> fetchFoodPlaceById(int id) async {
    try {
      _resultState = FoodPlaceDetailLoadingState();
      notifyListeners();

      final result = await _apiService.getFoodPlaceDetailById(id);

      _resultState = FoodPlaceDetailLoadedState(data: result);
    } catch (e) {
      _resultState = FoodPlaceDetailErrorState(error: e.toString());
    }

    notifyListeners();
  }

  void setError(String errorMessage) {
    _resultState = FoodPlaceDetailErrorState(error: errorMessage);
    notifyListeners();
  }
}