import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/data/models/main/camera/upload_response.dart';

class CameraProvider extends ChangeNotifier {
  String? imagePath;

  XFile? imageFile;

  final ApiService _apiService;

  CameraProvider(this._apiService);

  bool isUploading = false;
  String? message;
  UploadResponse? uploadResponse;

  void _setImage(XFile? value) {
    imageFile = value;
    imagePath = value?.path;
    notifyListeners();
  }

  void openCamera() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void openGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImage(pickedFile);
      _resetUploadState();
    }
  }

  void upload() async {
    if (imagePath == null || imageFile == null) return;

    isUploading = true;
    _resetUploadState();

    final bytes = await imageFile!.readAsBytes();
    final filename = imageFile!.name;

    uploadResponse = await _apiService.uploadDocument(bytes, filename);
    message = uploadResponse?.prediction;

    isUploading = false;
    notifyListeners();
  }

  void detailScreen(
    BuildContext context,
    String accessToken,
    String foodName,
  ) async {
    print(foodName);
    final idFood = await _apiService.searchScanFood(accessToken, foodName);

    print(idFood);

    if (idFood.idFood != null) {
      print("✅ Data makanan ditemukan dengan id: ${idFood.idFood}");

      Navigator.pushNamed(context, '/food-detail', arguments: idFood.idFood);
    } else {
      print("Makanan tidak ditemukan di server");
    }
  }

  void _resetUploadState() {
    message = null;
    uploadResponse = null;
    notifyListeners();
  }
}
