import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class SwitchToLightTheme extends ThemeEvent {}

class SwitchToDarkTheme extends ThemeEvent {}

class SwitchToDeviceTheme extends ThemeEvent {}
