import 'package:flutter/material.dart';
import 'package:mobile_apps/presentation/styles/color/jejak_rasa_color.dart';
import 'package:mobile_apps/presentation/styles/typography/jejak_rasa_text_style.dart';

class JejakRasaTheme {
  static double defaultPadding = 24.0;

  static TextTheme get _textThemeLight {
    return TextTheme(
      titleLarge: JejakRasaTextStyle.header.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      titleMedium: JejakRasaTextStyle.tittle.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      titleSmall: JejakRasaTextStyle.subHeader.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      bodyLarge: JejakRasaTextStyle.deskripsi.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      bodyMedium: JejakRasaTextStyle.subTittle.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      bodySmall: JejakRasaTextStyle.text.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      displayLarge: JejakRasaTextStyle.subText.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      displayMedium: JejakRasaTextStyle.subSubText.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
      displaySmall: JejakRasaTextStyle.subSubSubText.copyWith(
        color: JejakRasaColor.tersier.color,
      ),
    );
  }

  static TextTheme get _textThemeDark {
    return TextTheme(
      titleLarge: JejakRasaTextStyle.header.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      titleMedium: JejakRasaTextStyle.tittle.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      titleSmall: JejakRasaTextStyle.subHeader.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      bodyLarge: JejakRasaTextStyle.deskripsi.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      bodyMedium: JejakRasaTextStyle.subTittle.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      bodySmall: JejakRasaTextStyle.text.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      displayLarge: JejakRasaTextStyle.subText.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      displayMedium: JejakRasaTextStyle.subSubText.copyWith(
        color: JejakRasaColor.primary.color,
      ),
      displaySmall: JejakRasaTextStyle.subSubSubText.copyWith(
        color: JejakRasaColor.primary.color,
      ),
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textThemeLight.titleSmall,
      backgroundColor: JejakRasaColor.secondary.color,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: _textThemeLight,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: JejakRasaColor.secondary.color,
        selectedItemColor: JejakRasaColor.tersier.color,
        unselectedItemColor: JejakRasaColor.primary.color,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: JejakRasaColor.primary.color,
        onPrimary: JejakRasaColor.tersier.color,
        secondary: JejakRasaColor.secondary.color,
        onSecondary: JejakRasaColor.accent.color,
        error: JejakRasaColor.error.color,
        onError: JejakRasaColor.error.color,
        surface: JejakRasaColor.primary.color,
        onSurface: JejakRasaColor.accent.color,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      textTheme: _textThemeDark,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: JejakRasaColor.secondary.color,
        selectedItemColor: JejakRasaColor.tersier.color,
        unselectedItemColor: JejakRasaColor.accent.color,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: JejakRasaColor.tersier.color,
        onPrimary: JejakRasaColor.primary.color,
        secondary: JejakRasaColor.secondary.color,
        onSecondary: JejakRasaColor.accent.color,
        error: JejakRasaColor.error.color,
        onError: JejakRasaColor.error.color,
        surface: JejakRasaColor.tersier.color,
        onSurface: JejakRasaColor.accent.color,
      ),
    );
  }
}
