import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/ui/theme/app_theme.dart';

/// Provider pour gérer le thème de l'application (clair/sombre).
///
/// Persiste la préférence de thème dans Hive et notifie les widgets
/// lors des changements pour reconstruire l'interface.
///
/// Utilise [AppTheme.lightTheme] et [AppTheme.darkTheme] pour les thèmes.
class ThemeProvider with ChangeNotifier {
  late Box _themesBox;
  late ThemeData _themeData;

  ThemeProvider();

  Future<void> initHive() async {
    _themesBox = await Hive.openBox("themesBox");
    bool isDark = _themesBox.get("isDarkMode", defaultValue: false);
    _themeData = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    notifyListeners();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == AppTheme.darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _themesBox.put("isDarkMode", isDarkMode);
    notifyListeners();
  }

  void toggleTheme() {
    themeData = isDarkMode ? AppTheme.lightTheme : AppTheme.darkTheme;
  }
}
