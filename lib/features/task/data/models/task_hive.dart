import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task_hive.g.dart';

@HiveType(typeId: 1) // typeId 0: RegistrationEntity
class Task extends Equatable {
  const Task({
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    required this.startDate,
    required this.dueDate,
    required this.isDone,
    required this.synced,
    required this.uid,
    required this.email,
    this.subtasks = const [],
  });

  @HiveField(0)
  final int taskId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime dueDate;

  @HiveField(6)
  final bool isDone;

  @HiveField(7)
  final bool synced;

  @HiveField(8)
  final String uid;

  @HiveField(9)
  final String email;

  @HiveField(10)
  final List<Subtask> subtasks;

  Task copyWith({
    int? taskId,
    String? title,
    String? description,
    String? priority,
    DateTime? startDate,
    DateTime? dueDate,
    bool? isDone,
    bool? synced,
    String? uid,
    String? email,
    List<Subtask>? subtasks,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      synced: synced ?? this.synced,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      subtasks: subtasks ?? this.subtasks,
    );
  }

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

@HiveType(typeId: 2) // typeId 0: RegistrationEntity, 1: Task
class Subtask extends Equatable {
  const Subtask({
    required this.id,
    required this.title,
    required this.isDone,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isDone;

  @override
  List<Object?> get props => [id, title, isDone];
}
