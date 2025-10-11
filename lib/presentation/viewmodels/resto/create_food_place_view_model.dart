import 'package:flutter/material.dart';

import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/create_food_place_request.dart';
import '../../../data/models/main/resto/create_food_place_response.dart';


class CreateFoodPlaceViewModel extends ChangeNotifier {
  final ApiService _apiService;

  CreateFoodPlaceViewModel({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;
  CreateFoodPlaceResponse? _foodPlaceResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CreateFoodPlaceResponse? get foodPlaceResponse => _foodPlaceResponse;

  Future<void> createFoodPlace(CreateFoodPlaceRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _foodPlaceResponse = null;
    notifyListeners();

    try {
      final response = await _apiService.createFoodPlace(request);
      _foodPlaceResponse = response;
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }

    notifyListeners();
  }
}