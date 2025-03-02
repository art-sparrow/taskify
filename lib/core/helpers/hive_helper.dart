import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';

abstract class HiveHelper {
  // Init
  Future<void> initBoxes();

  // Auth
  Future<void> persistUserProfile({
    required RegistrationEntity userProfile,
  });

  RegistrationEntity? retrieveUserProfile();

  // Tasks
  Future<void> saveTask({required Task task});

  Future<List<Task>> getTasks();

  Future<void> deleteTask({required String taskId});

  // Clear
  Future<void> clearHiveDB();
  Future<void> clearTasksBox();
}

class HiveHelperImplementation implements HiveHelper {
  final _logger = Logger();

  @override
  Future<void> initBoxes() async {
    try {
      await Hive.initFlutter();

      Hive
        ..registerAdapter(RegistrationEntityAdapter())
        ..registerAdapter(TaskAdapter())
        ..registerAdapter(SubtaskAdapter());

      await Hive.openBox<dynamic>('taskify_dev');
      await Hive.openBox<RegistrationEntity>('user_box');
      await Hive.openBox<Task>('tasks_box');
    } catch (e) {
      _logger.e('Hive init failed: $e');
    }
  }

  @override
  Future<void> clearHiveDB() async {
    await Hive.box<dynamic>('taskify_dev').clear();
    await Hive.box<RegistrationEntity>('user_box').clear();
    await Hive.box<Task>('tasks_box').clear();
  }

  @override
  Future<void> clearTasksBox() async {
    await Hive.box<Task>('tasks_box').clear();
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

  @override
  Future<void> saveTask({required Task task}) async {
    await Hive.box<Task>('tasks_box').put(task.taskId.toString(), task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return Hive.box<Task>('tasks_box').values.toList();
  }

  @override
  Future<void> deleteTask({required String taskId}) async {
    await Hive.box<Task>('tasks_box').delete(taskId);
  }
}
