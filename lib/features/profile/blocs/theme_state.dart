import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.themeData,
    this.isDeviceTheme = false,
  });

  final ThemeData themeData;
  final bool isDeviceTheme;

  @override
  List<Object?> get props => [themeData, isDeviceTheme];
}
