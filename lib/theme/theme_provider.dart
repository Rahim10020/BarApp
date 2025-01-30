import 'package:flutter/material.dart';
import 'package:projet7/theme/dark_mode.dart';
import 'package:projet7/theme/light_mode.dart';

// cette classe me permet de switcher entre le lightMode et le dark Mode

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => themeData == darkMode;

  // setteur permettant de changer le themeData
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // fonction permettant de switcher entre le lightMode et le dark Mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
