import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();

  bool _isDarkTheme = true;

  ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  bool get isDarkTheme => _isDarkTheme;

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_theme', _isDarkTheme);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('dark_theme') ?? true;
    notifyListeners();
  }
}
