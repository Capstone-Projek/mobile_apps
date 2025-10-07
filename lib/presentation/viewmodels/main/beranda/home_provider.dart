import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/main/beranda/food_list_resul_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService;

  HomeProvider(this._apiService);

  FoodListResulState _resulState = FoodListNoneStae();

  FoodListResulState get resultState => _resulState;

  Future<void> fetchFoodList(String accessToken) async {
    try {
      _resulState = FoodListLoadingState();
      notifyListeners();

      final result = await _apiService.getFoodList(accessToken);

      if (result.isNotEmpty) {
        _resulState = FoodListLoadedState(data: result);
      } else {
        _resulState = FoodListErrorState(error: "Data Kosong");
      }
    } catch (e) {
      _resulState = FoodListErrorState(error: e.toString());
    }
    notifyListeners();
  }
}
