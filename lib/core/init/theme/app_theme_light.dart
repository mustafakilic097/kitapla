import 'package:flutter/material.dart';

import '../../extension/color_extension.dart';

class AppThemeLight {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    _instance ??= AppThemeLight._init();
    return _instance!;
  }

  AppThemeLight._init();

  ThemeData get theme => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0, centerTitle: true),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(color: Color.fromRGBO(66, 66, 66, 1)),
        backgroundColor: Color.fromRGBO(224, 224, 224, 1)
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: HexColor.fromHex("#77838F"),
          fontWeight: FontWeight.bold,fontSize: 14
        ),
        bodySmall: TextStyle(
          color: Colors.grey.shade500
        )
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white);
}
