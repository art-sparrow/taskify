import 'package:equatable/equatable.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  const AddTask(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  const UpdateTask(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  const DeleteTask(this.taskId);

  final int taskId;

  @override
  List<Object?> get props => [taskId];
}

class SearchTasks extends TaskEvent {
  const SearchTasks(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class FilterTasks extends TaskEvent {
  const FilterTasks({this.priority, this.isDone, this.dueDate});

  final String? priority;
  final bool? isDone;
  final DateTime? dueDate;

  @override
  List<Object?> get props =>
      [priority ?? '', isDone ?? false, dueDate ?? DateTime.now()];
}
