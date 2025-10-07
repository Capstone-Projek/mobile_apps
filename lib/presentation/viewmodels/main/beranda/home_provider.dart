import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/main/beranda/food_list_resul_state.dart';
import 'package:mobile_apps/presentation/static/main/beranda/search_food_result_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService;

  HomeProvider(this._apiService);

  FoodListResulState _resulState = FoodListNoneStae();

  FoodListResulState get resultState => _resulState;

  SearchFoodResultState _searchState = SearchFoodNoneState();

  SearchFoodResultState get searchState => _searchState;

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

  Future<void> searchFood(String accessToken, String searchFood) async {
    try {
      _searchState = SearchFoodLoadingState();
      notifyListeners();

      final result = await _apiService.getSearcFood(accessToken, searchFood);
   
      if (result.foodName == "") {
        _searchState = SearchFoodErrorState(error: "No Food name found it");
      } else {
        _searchState = SearchFoodLoadedState(data: result);
      }
      notifyListeners();
    } catch (e) {
      _searchState = SearchFoodErrorState(
        error: "Gagal menampilkan nama makanan",
      );
      notifyListeners();
    }
  }

  Future<void> resetSearch() async {
    _searchState = SearchFoodNoneState();
    notifyListeners();
  }
}
