import 'package:flutter/material.dart';
import 'package:mobile_apps/core/service/local/shared_preferences_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferencesService _service;

  SharedPreferencesProvider(this._service);

  String _message = "";
  String get message => _message;

  bool? _showMainScreen;
  bool? get showMainScreen => _showMainScreen;

  bool? _isDarkTheme;
  bool? get isDarkTheme => _isDarkTheme;

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
}
