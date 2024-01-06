import 'package:flutter/material.dart';

class AppThemeDark {
  static AppThemeDark? _instance;
  static AppThemeDark get instance {
    _instance ??= AppThemeDark._init();
    return _instance!;
  }

  AppThemeDark._init();

  ThemeData get theme => ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade700,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          iconTheme: const IconThemeData(color: Colors.white)),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(color: Color.fromRGBO(66, 66, 66, 1)),
        backgroundColor: Color.fromRGBO(117, 117, 117, 1)
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade700,
          selectedItemColor: Colors.grey.shade100,
          unselectedItemColor: Colors.grey.shade500),
      textTheme: TextTheme(
          headlineSmall: TextStyle(color: Colors.indigo.shade100, fontWeight: FontWeight.bold, fontSize: 14),
          bodySmall: TextStyle(color: Colors.grey.shade500)),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey.shade800);
}
