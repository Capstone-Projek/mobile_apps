import 'package:flutter/foundation.dart';

import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/food_place_search_response.dart';


class FoodPlaceSearchViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FoodPlaceSearchResponse? _searchResult;
  FoodPlaceSearchResponse? get searchResult => _searchResult;

  Future<void> searchFoodPlace(String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.searchFoodPlace(name);
      _searchResult = result;
    } catch (e) {
      _errorMessage = e.toString();
      _searchResult = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}
