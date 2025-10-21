import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/review/review_result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService _apiService;

  ReviewProvider(this._apiService);

  ReviewResultState _resulState = ReviewNoneState();
  
  ReviewResultState get resultState => _resulState;

  Future<void> fetchReviewByFoodId(int id) async {
    try {
      _resulState = ReviewLoadingState();
      notifyListeners();

      final result = await _apiService.getReviewByFoodId(id);

      if (result.isNotEmpty) {
        _resulState = ReviewLoadedState(data: result);
      } else {
        _resulState = ReviewErrorState(error: "Data Kosong");
      }
    } catch (e) {
      print(e.toString());
      _resulState = ReviewErrorState(error: e.toString());
    }
    notifyListeners();
  }
}