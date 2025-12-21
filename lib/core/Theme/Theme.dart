import 'package:flutter/material.dart';
import 'package:med/core/Theme/AppBaretheme.dart';
import 'package:med/core/Theme/appColors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.blue,
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: AppAppBar.appBarTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(160, 45),
      backgroundColor: AppColors.blue,
      foregroundColor: AppColors.white,
      textStyle: const TextStyle(
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(160, 45),
      foregroundColor: AppColors.blue,
      side: const BorderSide(color: AppColors.blue),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      textStyle: const TextStyle(
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
);

}
