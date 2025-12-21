// button_theme.dart
import 'package:flutter/material.dart';
import 'package:med/core/Theme/appColors.dart';

class AppButtonTheme {
  AppButtonTheme._();

  static const ButtonThemeData buttonTheme = ButtonThemeData(
    buttonColor: AppColors.blue,
    textTheme: ButtonTextTheme.primary,
  );

  static ElevatedButton customElevatedButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = AppColors.blue,
    Color textColor = AppColors.white,
    double elevation = 2.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
  })  {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: Text(label),
    );
  }
}