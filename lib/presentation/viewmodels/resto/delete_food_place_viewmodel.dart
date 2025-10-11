import 'package:flutter/material.dart';

import '../../../core/service/api/api_service.dart';
 // Ganti dengan path ke ApiService Anda

class DeleteFoodPlaceViewModel extends ChangeNotifier {
  final ApiService _apiService;

  DeleteFoodPlaceViewModel({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> deleteFoodPlace(int id) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final message = await _apiService.deleteFoodPlace(id);
      _successMessage = message;
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception:', '').trim()
          : "An unknown error occurred.";
      _isLoading = false;
    }

    notifyListeners();
  }

  // Fungsi untuk mereset pesan setelah ditampilkan
  void resetMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}