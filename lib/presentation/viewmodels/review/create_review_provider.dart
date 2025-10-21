import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/presentation/static/review/create_review_result_state.dart';

class CreateReviewProvider extends ChangeNotifier {
  final ApiService _apiService;

  CreateReviewProvider(this._apiService);

  CreateReviewResultState _state = CreateReviewNoneState();
  CreateReviewResultState get state => _state;

  void _setState(CreateReviewResultState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<bool> createReview(Map<String, dynamic> data) async {
    try {
      _setState(CreateReviewLoadingState());

      final int idFood = data["id_food"];
      final String reviewDesc = data["review_desc"];
      final String idUser = data["id_user"];

      // Validasi input
      if (reviewDesc.isEmpty) {
        _setState(CreateReviewErrorState(error: "Review tidak boleh kosong"));
        return false;
      }
      if (idUser.isEmpty) {
        _setState(CreateReviewErrorState(error: "Id user kosong"));
        return false;
      }
      if (idFood == 0) {
        _setState(CreateReviewErrorState(error: "Id makanan kosong"));
        return false;
      }

      final newReview = await _apiService.createReview(
        idFood: idFood,
        reviewDesc: reviewDesc,
        idUser: idUser,
      );

      _setState(CreateReviewLoadedState(data: [newReview]));
      return true;
    } on SocketException {
      _setState(CreateReviewErrorState(error: "Tidak ada koneksi internet"));
      return false;
    } catch (e) {
      _setState(CreateReviewErrorState(error: e.toString()));
      return false;
    }
  }
}
