import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyShowMain = "MY_MAIN_SCREEN";
  static const String _keyIsDarkTheme = "MY_THEME";
  
  static const String _keyAccessToken = "MY _ACCESS_TOKEN";
  static const String _keyRefreshToken = "MY_REFRESH_TOKEN";
  static const String _keyShowEmail = "MY_SHOW_EMAIL";
  static const String _keyShowUsername = "MY_SHOW_USERNAME";

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
