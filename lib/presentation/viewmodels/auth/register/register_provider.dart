import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/data/models/auth/register/user_register_request.dart';
import 'package:mobile_apps/presentation/static/auth/register_state/register_result_state.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService _apiService;

  RegisterProvider(this._apiService);

  RegisterResultState _resultState = RegisterResultNoneState();

  RegisterResultState get resultState => _resultState;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  Future<void> registerUser(UserRegisterRequest user) async {
    try {
      _resultState = RegisterResultLoadingState();
      notifyListeners();

      final result = await _apiService.registerUser(user);

      if (result.message != "Registrasi berhasil!") {
        _resultState = RegisterResultErrorState(error: "Failed to register");
        notifyListeners();
      } else {
        _resultState = RegisterResultLoadedState(
          data: result.userResponseModel,
        );
        notifyListeners();
      }
    } catch (e) {
      _resultState = RegisterResultErrorState(error: "Failed to register");
      notifyListeners();
    }
  }

  void resetState() {
    _resultState = RegisterResultNoneState();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}
