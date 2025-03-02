import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetService {
  static Future<bool> check() async => InternetConnection().hasInternetAccess;
}
