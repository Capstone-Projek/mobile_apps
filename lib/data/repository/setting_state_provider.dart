import 'package:flutter/widgets.dart';
import 'package:mobile_apps/core/utils/setting_state.dart';

class SettingStateProvider extends ChangeNotifier {
  SettingState _isDarkThemeState = SettingState.enable;
  SettingState get isDarkThemeState => _isDarkThemeState;

  set isDarkThemeState(SettingState value){
    _isDarkThemeState = value;
    notifyListeners();
  }

  
}