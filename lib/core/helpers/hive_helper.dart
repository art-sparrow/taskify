import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';

abstract class HiveHelper {
  // Init
  Future<void> initBoxes();

  // Auth
  Future<void> persistUserProfile({
    required RegistrationEntity userProfile,
  });

  RegistrationEntity? retrieveUserProfile();

  // Clear
  Future<void> clearHiveDB();
}

class HiveHelperImplementation implements HiveHelper {
  final _logger = Logger();

  @override
  Future<void> initBoxes() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(RegistrationEntityAdapter());
      await Hive.openBox<dynamic>('taskify_dev');
      await Hive.openBox<RegistrationEntity>('user_box');
    } catch (e) {
      _logger.e('Hive init failed: $e');
    }
  }

  @override
  Future<void> clearHiveDB() async {
    await Hive.box<dynamic>('taskify_dev').clear();
    await Hive.box<RegistrationEntity>('user_box').clear();
  }

  @override
  Future<void> persistUserProfile({
    required RegistrationEntity userProfile,
  }) async {
    await Hive.box<RegistrationEntity>('user_box')
        .put('currentUser', userProfile);
    _logger.i('Persisted user profile: ${userProfile.email}');
  }

  @override
  RegistrationEntity? retrieveUserProfile() {
    final user = Hive.box<RegistrationEntity>('user_box').get('currentUser');
    _logger.i('Retrieved user profile: ${user?.email ?? 'none'}');
    return user;
  }
}
