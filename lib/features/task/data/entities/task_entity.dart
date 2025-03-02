import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.taskId, // Unique ID
    required this.title,
    required this.description,
    required this.priority,
    required this.startDate,
    required this.dueDate,
    required this.isDone,
    required this.synced,
    required this.uid, // User ID
    required this.email,
    this.subtasks,
  });

  final int taskId;
  final String title;
  final String description;
  final String priority;
  final DateTime startDate;
  final DateTime dueDate;
  final bool isDone;
  final bool synced;
  final String uid;
  final String email;
  final List<Subtask>? subtasks;

  @override
  List<Object?> get props => [
        taskId,
        title,
        description,
        priority,
        startDate,
        dueDate,
        isDone,
        synced,
        uid,
        email,
        subtasks,
      ];
}

class Subtask extends Equatable {
  const Subtask({
    required this.id,
    required this.title,
    required this.isDone,
  });

  final int id;
  final String title;
  final bool isDone;

  @override
  List<Object?> get props => [id, title, isDone];
}
