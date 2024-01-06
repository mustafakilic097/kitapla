import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/enum/app_theme_enum.dart';
import '../cache/locale_manager.dart';
import 'app_theme_dark.dart';
import 'app_theme_light.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = LocaleManager.instance.getStringValue("theme") == "DARK"
      ? AppThemeDark.instance.theme
      : AppThemeLight.instance.theme;
  ThemeData get currentTheme => _currentTheme;

  Future<void> changeTheme(AppThemes theme) async {
    if (theme == AppThemes.DARK) {
      _currentTheme = AppThemeDark.instance.theme;
      await LocaleManager.instance.setStringValue("theme", AppThemes.DARK.name);
    } else {
      _currentTheme = AppThemeLight.instance.theme;
      await LocaleManager.instance.setStringValue("theme", AppThemes.LIGHT.name);
    }
    notifyListeners();
  }
}

final themeNotifierProvider = ChangeNotifierProvider((ref) => ThemeNotifier());
