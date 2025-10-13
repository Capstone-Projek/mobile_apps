import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  SharedPreferencesService(this._preferences);

  static const String _keyShowMain = "MY_MAIN_SCREEN";
  static const String _keyIsDarkTheme = "MY_THEME";

  static const String _keyAccessToken = "MY_ACCESS_TOKEN";
  static const String _keyRefreshToken = "MY_REFRESH_TOKEN";
  static const String _keyShowEmail = "MY_SHOW_EMAIL";
  static const String _keyShowUsername = "MY_SHOW_USERNAME";
  static const String _keyShowRole = "MY_SHOW_ROLE";

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

  Future<void> showAccessToken(String accessToken) async {
    try {
      await _preferences.setString(_keyAccessToken, accessToken);
    } catch (e) {
      throw Exception("Shared preference cannot save accessToken");
    }
  }

  String getShowAccessToken() {
    return _preferences.getString(_keyAccessToken) ?? "";
  }

  Future<void> showRefreshToken(String refreshToken) async {
    try {
      await _preferences.setString(_keyRefreshToken, refreshToken);
    } catch (e) {
      throw Exception("Shared preference cannot save refreshToken");
    }
  }

  String getShowRefreshToken() {
    return _preferences.getString(_keyRefreshToken) ?? "";
  }

  Future<void> showEmail(String showEmail) async {
    try {
      await _preferences.setString(_keyShowEmail, showEmail);
    } catch (e) {
      throw Exception("Shared preference cannot save showEmail");
    }
  }

  String getShowEmail() {
    return _preferences.getString(_keyShowEmail) ?? "";
  }

  Future<void> showUsername(String showUsername) async {
    try {
      await _preferences.setString(_keyShowUsername, showUsername);
    } catch (e) {
      throw Exception("Shared preference cannot save showUsername");
    }
  }

  String getshowUsername() {
    return _preferences.getString(_keyShowUsername) ?? "";
  }

  Future<void> showRole(String showRole) async {
    try {
      await _preferences.setString(_keyShowRole, showRole);
    } catch (e) {
      throw Exception("Shared preference cannot save showRole");
    }
  }

  String getShowRole() {
    return _preferences.getString(_keyShowRole) ?? "";
  }
}
