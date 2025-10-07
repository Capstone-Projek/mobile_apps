import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/data/models/main/profile/change_profile_request.dart';
import 'package:mobile_apps/presentation/static/profile/change_profile_result_state.dart';

class ChangeProfileProvider extends ChangeNotifier {
  final ApiService _apiService;

  ChangeProfileProvider(this._apiService);

  ChangeProfileResultState _resultState = ChangeProfileResultNoneState();

  ChangeProfileResultState get resultState => _resultState;

  Future<void> changeProfile(ChangeProfileRequest data) async {
    try {
      _resultState = ChangeProfileResultLoadingState();
      notifyListeners();

      final result = await _apiService.changeProfile(data.name, data.email);

      _resultState = ChangeProfileResultLoadedState(
        message: result.message,
        data: result.data,
      );
      notifyListeners();
    } catch (e) {
      _resultState = ChangeProfileResultErrorState(
        error: "Failed to change profile",
      );
      notifyListeners();
    }
  }

  Future<void> resetState() async {
    _resultState = ChangeProfileResultNoneState();
    notifyListeners();
  }
}
