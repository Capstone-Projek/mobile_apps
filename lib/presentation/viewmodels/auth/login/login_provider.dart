import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/data/models/auth/login/user_login_request.dart';
import 'package:mobile_apps/presentation/static/auth/login_state/login_result_state.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService _apiService;

  LoginProvider(this._apiService);

  LoginResultState _resultState = LoginResultNoneState();

  LoginResultState get resultState => _resultState;

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  Future<void> loginUser(UserLoginRequest user) async {
    try {
      _resultState = LoginResultLoadingState();
      notifyListeners();

      final result = await _apiService.loginUser(user);
      print(result.message);

      if (result.message != "Login berhasil!") {
        _resultState = LoginResultErrorState(error: "Failed to login");
        notifyListeners();
      } else {
        _resultState = LoginResultLoadedState(
          dataUser: result.userResponseModel,
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
        notifyListeners();
      }
    } catch (e) {
      _resultState = LoginResultErrorState(error: "Failed to login");
      notifyListeners();
    }
  }

  void resetState() {
    _resultState = LoginResultNoneState();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}
