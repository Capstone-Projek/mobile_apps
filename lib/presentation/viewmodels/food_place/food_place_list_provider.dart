import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food_place/food_place_list_result_state.dart';

class FoodPlaceListProvider extends ChangeNotifier {
  final ApiService _apiService;

  FoodPlaceListProvider(this._apiService);

  FoodPlaceListResultState _resulState = FoodPlaceListNoneState();
  
  FoodPlaceListResultState get resultState => _resulState;

  Future<void> fetchFoodPlaceList(String accessToken) async {
    try {
      _resulState = FoodPlaceListLoadingState();
      notifyListeners();

      final result = await _apiService.getAllFoodPlace(accessToken);


      if (result.isNotEmpty) {
        _resulState = FoodPlaceListLoadedState(data: result);
      } else {
        _resulState = FoodPlaceListErrorState(error: "Data Kosong");
      }
    } catch (e) {
      _resulState = FoodPlaceListErrorState(error: e.toString());
    }
    notifyListeners();
  }
}