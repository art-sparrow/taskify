import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required int taskId, // Unique ID
    required String title,
    required String description,
    required String priority,
    required DateTime startDate,
    required DateTime dueDate,
    required bool isDone,
    required bool synced,
    required String uid, // User ID
    required String email,
    List<Subtask>? subtasks,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
class Subtask with _$Subtask {
  const factory Subtask({
    required int id,
    required String title,
    required bool isDone,
  }) = _Subtask;

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
}
