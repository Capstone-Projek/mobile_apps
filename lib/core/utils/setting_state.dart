enum SettingState {
  enable,
  dissable;

  bool get isEnable => this == SettingState.enable;
}
