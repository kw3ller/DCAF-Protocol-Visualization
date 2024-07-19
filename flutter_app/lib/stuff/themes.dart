import 'package:flutter/material.dart';

/// custom theme for all sites
CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  /// indicates witch theme is used currently
  static bool _darkMode = true;

  static Color _outlinedButtonColor = Color.fromRGBO(69, 213, 195, 1);

  ThemeMode get currentTheme => _darkMode ? ThemeMode.dark : ThemeMode.light;

  static Map<int, Color> _primarySwatchColorIntensity = {
    50: Color.fromRGBO(55, 170, 156, .1),
    100: Color.fromRGBO(55, 170, 156, .2),
    200: Color.fromRGBO(55, 170, 156, .3),
    300: Color.fromRGBO(55, 170, 156, .4),
    400: Color.fromRGBO(55, 170, 156, .5),
    500: Color.fromRGBO(55, 170, 156, .6),
    600: Color.fromRGBO(55, 170, 156, .7),
    700: Color.fromRGBO(55, 170, 156, .8),
    800: Color.fromRGBO(55, 170, 156, .9),
    900: Color.fromRGBO(55, 170, 156, 1),
  };

  static MaterialColor _primarySwatchColor =
      MaterialColor(0xFF29A19C, _primarySwatchColorIntensity);

  /// to change theme
  void toggleTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  /// lightTheme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color.fromRGBO(69, 98, 104, 1),
      backgroundColor: Color.fromRGBO(221, 221, 221, 1),
      scaffoldBackgroundColor: Color.fromRGBO(221, 221, 221, 1),

      popupMenuTheme: PopupMenuThemeData(
        color: Color.fromRGBO(185, 210, 210, 1),
      ),

      // this is the buttonColor
      primarySwatch: _primarySwatchColor,
      // should be the same
      accentColor: _primarySwatchColor,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black, fontSize: 18),
        bodyText2: TextStyle(color: Colors.black, fontSize: 16),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: _primarySwatchColor,
          ),
        ),
      ),
    );
  }

  /// darkTheme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Color.fromRGBO(39, 50, 58, 1),

      backgroundColor: Color.fromRGBO(67, 80, 85, 1),
      scaffoldBackgroundColor: Color.fromRGBO(67, 80, 85, 1),

      popupMenuTheme: PopupMenuThemeData(
        color: Color.fromRGBO(185, 210, 210, 1),
      ),

      // this is the buttonColor
      primarySwatch: _primarySwatchColor,
      // should be the same
      accentColor: _primarySwatchColor,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.white),
        headline2: TextStyle(color: Colors.white),
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: _primarySwatchColor,
          ),
        ),
      ),
    );
  }

  static bool get darkMode {
    return _darkMode;
  }

  static Color get outlinedButtonColor {
    return _outlinedButtonColor;
  }
}
