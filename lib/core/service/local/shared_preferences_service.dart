import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyShowMain = "MY_MAIN_SCREEN";
  static const String _keyIsDarkTheme = "MY_THEME";

  Future<void> showMainScreen(bool showMainScreen) async {
    try {
      await _preferences.setBool(_keyShowMain, showMainScreen);
    } catch (e) {
      throw Exception("Shared preferences cannot setting");
    }
  }

  bool getShowMainScreen() {
    return _preferences.getBool(_keyShowMain) ?? false;
  }

  Future<void> saveIsDarkThemeValue(bool isDarkTheme) async {
    try {
      await _preferences.setBool(_keyIsDarkTheme, isDarkTheme);
    } catch (e) {
      throw Exception("Shared preferences cannot setting");
    }
  }

  bool getIsDarkThemeValue() {
    return _preferences.getBool(_keyIsDarkTheme) ?? false;
  }
}
