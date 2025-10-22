import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';

class DeleteFoodPlaceProvider extends ChangeNotifier {
  final ApiService _apiService;

  DeleteFoodPlaceProvider(this._apiService);

  bool isLoading = false;
  String? errorMessage;

  Future<String> deleteFoodPlace(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      final message = await _apiService.deleteFoodPlace(id);
      return message; // Return success message
    } catch (e) {
      errorMessage = "Gagal menghapus resto: $e";
      return errorMessage!; // Return error message
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
