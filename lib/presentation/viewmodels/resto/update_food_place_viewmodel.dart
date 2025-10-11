import 'package:flutter/material.dart';

import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/create_food_place_request.dart';
import '../../../data/models/main/resto/create_food_place_response.dart';


class UpdateFoodPlaceViewModel extends ChangeNotifier {
  final ApiService _apiService;

  UpdateFoodPlaceViewModel({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;
  CreateFoodPlaceResponse? _updatedFoodPlace;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CreateFoodPlaceResponse? get updatedFoodPlace => _updatedFoodPlace;

  Future<void> updateFoodPlace(int id, CreateFoodPlaceRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _updatedFoodPlace = null;
    notifyListeners();

    try {
      final response = await _apiService.updateFoodPlace(id, request);
      _updatedFoodPlace = response;
      _isLoading = false;
    } catch (e) {
      // Tangani error, hilangkan 'Exception:' jika ada
      _errorMessage = e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception:', '').trim()
          : "Gagal memperbarui tempat makan.";
      _isLoading = false;
    }

    notifyListeners();
  }

  // Fungsi untuk mereset state error/success
  void resetState() {
    _errorMessage = null;
    _updatedFoodPlace = null;
    notifyListeners();
  }
}