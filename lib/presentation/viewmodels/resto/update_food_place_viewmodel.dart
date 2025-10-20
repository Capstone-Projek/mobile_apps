import 'dart:io';
import 'package:flutter/material.dart' hide ImageInfo;
import '../../../core/service/api/api_service.dart';
import '../../../data/models/main/resto/create_food_place_request.dart';
import '../../../data/models/main/resto/resto_food_model.dart';

class UpdateFoodPlaceViewModel extends ChangeNotifier {
  final ApiService _apiService;

  UpdateFoodPlaceViewModel({required ApiService apiService})
      : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;
  RestoPlaceModel? _updatedFoodPlace;

  List<String> existingImages = [];
  List<File> newImages = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RestoPlaceModel? get updatedFoodPlace => _updatedFoodPlace;

  // 🟢 Set gambar lama
  void setInitialImages(List<String> images) {
    existingImages = List.from(images);
    notifyListeners();
  }

  // 🟢 Tambah gambar baru
  void addNewImages(List<File> images) {
    newImages.addAll(images);
    notifyListeners();
  }

  // 🟢 Hapus gambar lama
  void removeExistingImage(int index) {
    if (index < existingImages.length) {
      existingImages.removeAt(index);
      notifyListeners();
    }
  }

  // 🟢 Hapus gambar baru
  void removeNewImage(int index) {
    if (index < newImages.length) {
      newImages.removeAt(index);
      notifyListeners();
    }
  }

  // =====================================================
  // 🟩 Update data resto (tanpa gambar)
  // =====================================================
  Future<void> updateFoodPlace(int id, CreateFoodPlaceRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.updateFoodPlace(id, request);
      _updatedFoodPlace = updated;
    } catch (e) {
      debugPrint("❌ Error updateFoodPlace: $e");
      _errorMessage = _formatError(e, "Gagal memperbarui data tempat makan.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // 🟪 Update gambar resto
  // =====================================================
  Future<void> updateFoodPlaceImages(int idFoodPlace) async {
    if (newImages.isEmpty) {
      _errorMessage = "Belum ada gambar baru yang dipilih.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ Ambil daftar URL hasil upload
      final imageUrls = await _apiService.updateFoodPlaceImages(
        idFoodPlace,
        newImages,
      );

      // 🔄 Update daftar lokal
      existingImages = List.from(imageUrls);
      newImages.clear();

      // 🔄 Perbarui model utama jika sudah pernah di-load
      if (_updatedFoodPlace != null) {
        _updatedFoodPlace = _updatedFoodPlace!.copyWith(
          images: imageUrls
              .map((url) => ImageInfo(
            idFoodPlace: idFoodPlace,
            idImagePlace: 0,
            imageUrl: url,
          ))
              .toList(),
        );
      }

      debugPrint("✅ Gambar berhasil diperbarui: $imageUrls");
    } catch (e) {
      debugPrint("❌ Error updateFoodPlaceImages: $e");
      _errorMessage =
          _formatError(e, "Gagal memperbarui gambar tempat makan.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // 🧹 Reset state
  // =====================================================
  void resetState() {
    _errorMessage = null;
    _updatedFoodPlace = null;
    existingImages.clear();
    newImages.clear();
    notifyListeners();
  }

  // =====================================================
  // 🔍 Helper error
  // =====================================================
  String _formatError(Object e, String fallback) {
    return e.toString().contains('Exception:')
        ? e.toString().replaceFirst('Exception:', '').trim()
        : fallback;
  }
}
