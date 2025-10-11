import 'package:flutter/foundation.dart';

import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/resto_food_model.dart';


class FoodPlaceDetailViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RestoPlaceModel? _foodPlace;
  RestoPlaceModel? get foodPlace => _foodPlace;

  Future<void> fetchFoodPlaceById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getFoodPlaceById(id);
      _foodPlace = result;
    } catch (e) {
      _errorMessage = e.toString();
      _foodPlace = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _foodPlace = null;
    _errorMessage = null;
    notifyListeners();
  }
}
