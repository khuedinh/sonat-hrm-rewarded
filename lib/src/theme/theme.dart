import 'package:flutter/material.dart';

class CustomAppTheme {
  CustomAppTheme._();

  static ThemeData getLightTheme(Color color) {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
            .copyWith(primary: color, onPrimary: Colors.white));
  }

  static ThemeData getDarkTheme(Color color) {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.dark)
            .copyWith(primary: color, onPrimary: Colors.white));
  }
}
