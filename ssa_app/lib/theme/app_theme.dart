import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Adjust the import path based on your project structure

class AppTheme {
  static ThemeData get lightTheme {
    // Define the light theme using custom colors
    return ThemeData(
      primaryColor: AppColors.prussianBlue, // Use custom color for primaryColor
      scaffoldBackgroundColor: AppColors.ghostWhite, // Custom background color
      cardColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        color: AppColors.paynesGray, // Custom AppBar color
      ),
      // You can define other customizations using AppColors
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.greenBlue, // Custom button color
      ),
      textTheme: const TextTheme(
        // Define text theme styles using AppColors if needed
        displayLarge: TextStyle(color: AppColors.prussianBlue),
        bodyLarge: TextStyle(color: AppColors.paynesGray),
      ),
      // Add other theme customizations here
    );
  }
}
