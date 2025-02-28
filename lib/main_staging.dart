import 'package:flutter/material.dart';
import 'package:taskify/app/app.dart';
import 'package:taskify/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap(() => const App());
}
