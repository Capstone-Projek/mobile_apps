import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/api/api_service.dart';
import 'package:mobile_apps/core/service/local/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;
  final ApiService _api;

  SharedPreferencesProvider(this._service, this._api);

  String _message = "";
  String get message => _message;
  late SharedPreferences _prefs;

  bool? _showMainScreen;
  bool? get showMainScreen => _showMainScreen;

  bool? _isDarkTheme;
  bool? get isDarkTheme => _isDarkTheme;

  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  String? _showEmail;
  String? get showEmail => _showEmail;

  String? _showUsername;
  String? get showUsername => _showUsername;

  Future<void> setShowMain(bool value) async {
    try {
      await _service.showMainScreen(value);
      _message = "Save main screen has been saved";
    } catch (e) {
      _message = "Failed to save your main screen";
    }
    notifyListeners();
  }

  void getShowMain() {
    try {
      _showMainScreen = _service.getShowMainScreen();
      _message = "Data succesfully received";
    } catch (e) {
      _message = "Failed to get your data";
      _showMainScreen = false;
    }
    notifyListeners();
  }

  Future<void> saveIsDarkThemeValue(bool value) async {
    try {
      await _service.saveIsDarkThemeValue(value);
      _message = "Your preferences theme has been saved";
    } catch (e) {
      _message = "failed to save your theme data";
    }
    notifyListeners();
  }

  void getIsDarkThemeValue() async {
    try {
      _isDarkTheme = _service.getIsDarkThemeValue();
      _message = "Data successfully received";
    } catch (e) {
      _message = "Failed to get your data";
    }
    notifyListeners();
  }

  Future<void> setAccessToken(String accessToken) async {
    try {
      await _service.showAccessToken(accessToken);
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your accessToken";
    }
  }

  void getAccessToken() async {
    try {
      _accessToken = _service.getShowAccessToken();
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your accessToken";
    }
    notifyListeners();
  }

  Future<void> setRefreshToken(String refreshToken) async {
    try {
      await _service.showRefreshToken(refreshToken);
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your refreshToken";
    }
  }

  void getRefreshToken() async {
    try {
      _refreshToken = _service.getShowRefreshToken();
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your refreshToken";
    }
    notifyListeners();
  }

  Future<void> setShowEmail(String showEmail) async {
    try {
      await _service.showEmail(showEmail);
      _message = "showEmail successfully received";
    } catch (e) {
      _message = "Failed to get your showEmail";
    }
  }

  void getshowEmail() async {
    try {
      _showEmail = _service.getShowEmail();
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your showEmail";
    }
    notifyListeners();
  }

  Future<void> setShowUsername(String showUsername) async {
    try {
      await _service.showUsername(showUsername);
      _message = "showUsername successfully received";
    } catch (e) {
      _message = "Failed to get your showUsername";
    }
  }

  void getshowUsername() async {
    try {
      _showUsername = _service.getshowUsername();
      _message = "AccessToken successfully received";
    } catch (e) {
      _message = "Failed to get your showUsername";
    }
    notifyListeners();
  }

  Future<void> loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    _showUsername = SharedPreferencesService(_prefs).getshowUsername();
    _showEmail = SharedPreferencesService(_prefs).getShowEmail();
    notifyListeners();
  }

  // Future<void> refreshAccessToken() async {
  //   try {
  //     if (_refreshToken == null) return;

  //     final newAccessToken = await _api.refreshToken(_refreshToken!);
  //     if (newAccessToken != null) {
  //       await setAccessToken(newAccessToken);
  //       _accessToken = newAccessToken;
  //       notifyListeners();
  //     } else {
  //       _message = "Failed to refresh AccessToken";
  //     }
  //   } catch (e) {
  //     _message = "Failed to refresh AccessToken";
  //   }
  // }

  //Panggil ini di initState MainScreen atau sebelum request API.
  Future<void> syncToken() async {
    getAccessToken();
    getRefreshToken();
  }
}
