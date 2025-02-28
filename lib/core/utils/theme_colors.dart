import 'package:flutter/material.dart';
import 'package:taskify/core/utils/app_colors.dart';

class ThemeColors {
  ThemeColors({
    required this.whiteColor,
    required this.blackColor,
    required this.greyColor,
    required this.backgroundColor,
    required this.textColor,
    required this.transparentColor,
    required this.primaryColor,
    required this.errorColor,
    required this.successColor,
    required this.accentColor,
    required this.warningColor,
  });

  final Color whiteColor;
  final Color blackColor;
  final Color greyColor;
  final Color backgroundColor;
  final Color textColor;
  final Color transparentColor;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Color accentColor;
  final Color warningColor;

  // Light theme
  static final lightThemeColors = ThemeColors(
    whiteColor: AppColors.white,
    blackColor: AppColors.black,
    greyColor: AppColors.greyDark,
    backgroundColor: AppColors.white,
    textColor: AppColors.greyDark,
    transparentColor: AppColors.transparent,
    primaryColor: AppColors.primary,
    successColor: AppColors.success,
    errorColor: AppColors.error,
    accentColor: AppColors.primaryLight,
    warningColor: AppColors.warning,
  );

  // Dark theme
  static final darkThemeColors = ThemeColors(
    whiteColor: AppColors.black,
    blackColor: AppColors.black,
    greyColor: AppColors.greyDark,
    backgroundColor: AppColors.black,
    textColor: AppColors.white,
    transparentColor: AppColors.transparent,
    primaryColor: AppColors.primary,
    successColor: AppColors.success,
    errorColor: AppColors.error,
    accentColor: AppColors.primaryLight,
    warningColor: AppColors.warning,
  );
}
