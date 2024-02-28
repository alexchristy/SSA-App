// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // Define the light theme
    return ThemeData(
      primarySwatch: Colors.blue,
      cardColor: Colors.white,
      // Add other theme customizations here
    );
  }

  // If you plan to support a dark theme in the future, you can also define it here
  static ThemeData get darkTheme {
    // Define the dark theme
    return ThemeData(
      brightness: Brightness.dark,
      // Additional dark theme customizations
    );
  }
}
