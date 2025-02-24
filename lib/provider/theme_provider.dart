import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/theme/dark_mode.dart';
import 'package:projet7/theme/light_mode.dart';

// cette classe me permet de switcher entre le lightMode et le dark Mode

class ThemeProvider with ChangeNotifier {
  late Box _themesBox;
  late ThemeData _themeData;

  ThemeProvider();

  Future<void> initHive() async {
    _themesBox = await Hive.openBox("themesBox");
    bool isDark = _themesBox.get("isDarkMode", defaultValue: false);
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _themesBox.put("isDarkMode", isDarkMode);
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? lightMode : darkMode;
  }
}
