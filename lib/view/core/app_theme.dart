import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  //---------TEMA TERANG----------
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColor.primary,
      scaffoldBackgroundColor: AppColor.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.background,
        foregroundColor: AppColor.text,
        elevation: 0,
      ),
      //TEXT
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColor.text),
        bodyMedium: TextStyle(color: AppColor.text),
      ),
      //BUTTON +
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.primaryLight,
      ),
      //BOTTOM NAVIGATION BAR
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColor.card,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: AppColor.muted,
      ),
      useMaterial3: true,
    );
  }

  //----------- DARK THEME ------------------
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColor.darkPrimary,
      scaffoldBackgroundColor: AppColor.darkBackground,
      cardColor: AppColor.darkCard,
      //TEXT
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColor.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColor.darkTextSecondary),
      ),
      //TOMBOL +
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.darkPrimary,
        foregroundColor: Colors.white,
      ),
      //TOMBOL NAVBAR
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColor.darkSurface,
        selectedItemColor: AppColor.darkPrimary,
        unselectedItemColor: Colors.grey,
      ),

      useMaterial3: true,
    );
  }
}
