import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/main/beranda/food_list_resul_state.dart';
import 'package:mobile_apps/presentation/static/main/beranda/resto_list_result_state.dart';
import 'package:mobile_apps/presentation/static/main/beranda/search_food_result_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService;

  HomeProvider(this._apiService);

  int _carouselActiveIndex = 0;
  int get carouselActiveIndex => _carouselActiveIndex;

  FoodListResulState _resulState = FoodListNoneStae();

  FoodListResulState get resultState => _resulState;

  SearchFoodResultState _searchState = SearchFoodNoneState();

  SearchFoodResultState get searchState => _searchState;

  RestoListResultState _restoState = RestoListNoneState();

  RestoListResultState get restoState => _restoState;

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

  Future<void> fetchRestoList(String accessToken) async {
    try {
      _restoState = RestoListLoadingState();
      notifyListeners();

      final result = await _apiService.getRestoList(accessToken);

      if (result.isNotEmpty) {
        _restoState = RestoListLoadedState(data: result);
        print("dari provider ${result.length}");
      } else {
        _restoState = RestoListErrorState(error: "Resto kosong");
      }
    } catch (e) {
      _restoState = RestoListErrorState(error: "Resto tidak ditemukan");
    }
    notifyListeners();
  }

  void setCarouselIndex(int index) {
    _carouselActiveIndex = index;
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
