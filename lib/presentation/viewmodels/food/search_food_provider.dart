import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/food/search_food_result_state.dart';

class SearchFoodProvider extends ChangeNotifier {
  final ApiService _apiService;

  SearchFoodProvider(this._apiService);

  SearchFoodResultState _resultState = SearchFoodResultNoneState();

  SearchFoodResultState get resultState => _resultState;

  Future<void> searchFood(String name) async {
    try {
      _resultState = SearchFoodResultLoadingState();
      notifyListeners();

      final result = await _apiService.searchFood(name);
      _resultState = SearchFoodResultLoadedState(data: result);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _resultState = SearchFoodResultErrorState(
        error: "Failed to search food",
      );
      notifyListeners();
    }
  }
}
