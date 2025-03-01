import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/core/utils/theme_colors.dart';
import 'package:taskify/features/profile/blocs/theme_event.dart';
import 'package:taskify/features/profile/blocs/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences,
        super(_getInitialTheme(sharedPreferences)) {
    on<SwitchToLightTheme>(_onSwitchToLightTheme);
    on<SwitchToDarkTheme>(_onSwitchToDarkTheme);
    on<SwitchToDeviceTheme>(_onSwitchToDeviceTheme);

    // Listen to system brightness changes
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      if (state.isDeviceTheme) {
        final brightness = PlatformDispatcher.instance.platformBrightness;
        add(
          brightness == Brightness.dark
              ? SwitchToDarkTheme()
              : SwitchToLightTheme(),
        );
      }
    };
  }

  final SharedPreferences _prefs;
  static const String _prefKey = 'theme_preference';
  static const String _deviceKey = 'isDeviceTheme';

  // Get the initial theme from SharedPreferences
  static ThemeState _getInitialTheme(SharedPreferences prefs) {
    final isDeviceTheme = prefs.getBool(_deviceKey) ?? false;
    final brightness = PlatformDispatcher.instance.platformBrightness;
    final isDark = prefs.getBool(_prefKey) ??
        (isDeviceTheme && brightness == Brightness.dark);
    return ThemeState(
      themeData: isDark
          ? _buildTheme(ThemeColors.darkThemeColors)
          : _buildTheme(ThemeColors.lightThemeColors),
      isDeviceTheme: isDeviceTheme,
    );
  }

  Future<void> _onSwitchToLightTheme(
    SwitchToLightTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeState(themeData: _buildTheme(ThemeColors.lightThemeColors)));
    await _prefs.setBool(_prefKey, false);
    await _prefs.setBool(_deviceKey, false);
  }

  Future<void> _onSwitchToDarkTheme(
    SwitchToDarkTheme event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeState(themeData: _buildTheme(ThemeColors.darkThemeColors)));
    await _prefs.setBool(_prefKey, true);
    await _prefs.setBool(_deviceKey, false);
  }

  // Event handler for switching to device theme
  Future<void> _onSwitchToDeviceTheme(
    SwitchToDeviceTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    final isDark = brightness == Brightness.dark;
    emit(
      ThemeState(
        themeData: isDark
            ? _buildTheme(ThemeColors.darkThemeColors)
            : _buildTheme(ThemeColors.lightThemeColors),
        isDeviceTheme: true,
      ),
    );
    await _prefs.setBool(_deviceKey, true);
  }

  static ThemeData _buildTheme(ThemeColors colors) {
    return ThemeData(
      brightness: colors == ThemeColors.darkThemeColors
          ? Brightness.dark
          : Brightness.light,
      scaffoldBackgroundColor: colors.backgroundColor,
      primaryColor: colors.primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundColor,
        surfaceTintColor: colors.transparentColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.textColor),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colors.textColor,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(color: colors.textColor, fontSize: 32),
        displaySmall: TextStyle(color: colors.textColor, fontSize: 28),
        headlineLarge: TextStyle(
          color: colors.textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(color: colors.textColor, fontSize: 22),
        headlineSmall: TextStyle(color: colors.textColor, fontSize: 20),
        titleLarge: TextStyle(
          color: colors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(color: colors.textColor, fontSize: 16),
        titleSmall: TextStyle(color: colors.textColor, fontSize: 14),
        bodyLarge: TextStyle(color: colors.textColor, fontSize: 16),
        bodyMedium: TextStyle(color: colors.textColor, fontSize: 14),
        bodySmall: TextStyle(color: colors.textColor, fontSize: 12),
        labelLarge: TextStyle(
          color: colors.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(color: colors.textColor, fontSize: 14),
        labelSmall: TextStyle(color: colors.textColor, fontSize: 12),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        modalBarrierColor: colors.transparentColor,
        elevation: 7,
        backgroundColor: colors.backgroundColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colors.textColor,
          backgroundColor: colors.primaryColor,
        ),
      ),
    );
  }
}
