import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';

class DeleteFoodProvider extends ChangeNotifier {
  final ApiService _apiService;

  DeleteFoodProvider(this._apiService);

  bool isLoading = false;

  Future<void> deleteFood(
    BuildContext context,
    int foodId,
    String foodName,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final message = await _apiService.deleteFood(foodId);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      Future.microtask(() {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        Future.microtask(() {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gagal menghapus '$foodName': $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
