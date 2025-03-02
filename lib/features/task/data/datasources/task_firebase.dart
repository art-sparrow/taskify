import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/core/services/internet_service.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';

class TaskFirebase {
  TaskFirebase({
    FirebaseFirestore? firestore,
    HiveHelper? hiveHelper,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _hiveHelper = hiveHelper ?? getIt<HiveHelper>();

  final FirebaseFirestore _firestore;
  final HiveHelper _hiveHelper;

  Future<void> saveTask(Task task) async {
    try {
      // Check internet connectivity
      final hasInternet = await InternetService.check();

      if (hasInternet) {
        // Save to Firestore
        await _firestore.collection('tasks').doc(task.taskId.toString()).set({
          'taskId': task.taskId,
          'title': task.title,
          'description': task.description,
          'priority': task.priority,
          'startDate': task.startDate.toIso8601String(),
          'dueDate': task.dueDate.toIso8601String(),
          'isDone': task.isDone,
          'synced': true,
          'uid': task.uid,
          'email': task.email,
          'subtasks': task.subtasks
              .map(
                (subtask) => {
                  'id': subtask.id,
                  'title': subtask.title,
                  'isDone': subtask.isDone,
                },
              )
              .toList(),
        });

        // Save to Hive with synced: true
        final syncedTask = Task(
          taskId: task.taskId,
          title: task.title,
          description: task.description,
          priority: task.priority,
          startDate: task.startDate,
          dueDate: task.dueDate,
          isDone: task.isDone,
          synced: true,
          uid: task.uid,
          email: task.email,
          subtasks: task.subtasks,
        );
        await _hiveHelper.saveTask(task: syncedTask);
      } else {
        // Save to Hive with synced: false
        final unsyncedTask = Task(
          taskId: task.taskId,
          title: task.title,
          description: task.description,
          priority: task.priority,
          startDate: task.startDate,
          dueDate: task.dueDate,
          isDone: task.isDone,
          synced: false,
          uid: task.uid,
          email: task.email,
          subtasks: task.subtasks,
        );
        await _hiveHelper.saveTask(task: unsyncedTask);
        log('Saved to Hive with synced: false due to no internet');
      }
    } catch (e) {
      log('Failed to save task: $e');
      // Fallback to Hive with synced: false
      final fallbackTask = Task(
        taskId: task.taskId,
        title: task.title,
        description: task.description,
        priority: task.priority,
        startDate: task.startDate,
        dueDate: task.dueDate,
        isDone: task.isDone,
        synced: false,
        uid: task.uid,
        email: task.email,
        subtasks: task.subtasks,
      );
      await _hiveHelper.saveTask(task: fallbackTask);
      throw Exception('Failed to save task: $e');
    }
  }

  Future<List<Task>> getTasks(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          taskId: data['taskId'] is int
              ? data['taskId'] as int
              : int.parse(
                  data['taskId'].toString(),
                ),
          title: data['title'] as String,
          description: data['description'] as String,
          priority: data['priority'] as String,
          startDate: DateTime.parse(data['startDate'] as String),
          dueDate: DateTime.parse(data['dueDate'] as String),
          isDone: data['isDone'] as bool,
          synced: true,
          uid: data['uid'] as String,
          email: data['email'] as String,
          subtasks: (data['subtasks'] as List<dynamic>? ?? []).map((sub) {
            final subData = sub as Map<String, dynamic>;
            return Subtask(
              id: subData['id'] is int
                  ? subData['id'] as int
                  : int.parse(subData['id'].toString()),
              title: subData['title'] as String,
              isDone: subData['isDone'] as bool,
            );
          }).toList(),
        );
      }).toList();
      return tasks;
    } catch (e) {
      log('Failed to fetch tasks from Firestore: $e');
      // Fallback to Hive
      final localTasks = await _hiveHelper.getTasks();
      return localTasks;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final hasInternet = await InternetService.check();
      if (hasInternet) {
        await _firestore.collection('tasks').doc(taskId).delete();
      }
      await _hiveHelper.deleteTask(taskId: taskId);
    } catch (e) {
      log('Failed to delete task: $e');
      throw Exception('Failed to delete task: $e');
    }
  }
}
