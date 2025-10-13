import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';

class CreateFoodProvider extends ChangeNotifier {
  final ApiService _apiService;

  CreateFoodProvider(this._apiService);

  bool isLoading = false;

  Future<void> createFood(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final List<File> files =
          (data["images"] as List?)?.map((e) => File(e.path)).toList() ?? [];

      final newFood = await _apiService.createFood(
        foodName: data["food_name"],
        category: data["category"],
        from: data["from"],
        desc: data["desc"],
        history: data["history"],
        material: data["material"],
        recipes: data["recipes"],
        timeCook: data["time_cook"],
        serving: data["serving"],
        vidioUrl: data["vidio_url"],
        images: files,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil menambahkan ${newFood.foodName}"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menambahkan makanan: $e"),
            backgroundColor: JejakRasaColor.error.color,
          ),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
