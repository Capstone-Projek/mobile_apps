import 'package:flutter/material.dart';

// Ganti dengan path yang benar
import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/create_food_place_request.dart';

// Import model response yang benar yang merepresentasikan output akhir dari BE
import '../../../data/models/main/resto/resto_food_model.dart';


class CreateFoodPlaceViewModel extends ChangeNotifier {
  final ApiService _apiService;

  CreateFoodPlaceViewModel({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;

  // State untuk menyimpan RestoPlaceModel yang baru dibuat (termasuk gambar)
  RestoPlaceModel? _createdFoodPlace;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getter yang mengembalikan RestoPlaceModel lengkap
  RestoPlaceModel? get createdFoodPlace => _createdFoodPlace;

  /**
   * Memproses pembuatan tempat makan baru, termasuk pengiriman data dan file gambar.
   * Karena BE sudah terintegrasi, ini adalah operasi satu langkah di sisi klien.
   */
  Future<void> createFoodPlace(CreateFoodPlaceRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    _createdFoodPlace = null;
    notifyListeners();

    try {
      // Panggil API Service yang melakukan request Multipart (data + file)
      final response = await _apiService.createFoodPlace(request);

      // Simpan RestoPlaceModel yang dikembalikan oleh BE
      _createdFoodPlace = response;
    } catch (e) {
      // Penanganan error, menampilkan pesan yang lebih mudah dibaca
      _errorMessage = e.toString().contains('Exception:')
          ? e.toString().replaceFirst('Exception:', '').trim()
          : "Gagal membuat tempat makan. Mohon coba lagi.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}