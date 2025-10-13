import 'package:flutter/foundation.dart';

import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/resto_food_model.dart';

class MapViewModel extends ChangeNotifier {
  final ApiService _apiService;
  MapViewModel({required ApiService apiService}) : _apiService = apiService; // Ganti konstruktor

  List<RestoPlaceModel> _foodPlaces = [];
  List<RestoPlaceModel> get foodPlaces => _foodPlaces;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFoodPlaces() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getFoodPlaces();
      _foodPlaces = result;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
