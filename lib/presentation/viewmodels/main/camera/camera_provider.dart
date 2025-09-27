import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraProvider extends ChangeNotifier {
  String? imagePath;

  XFile? imageFile;

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
    }
  }

  void openGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImage(pickedFile);
    }
  }
}
