import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_event.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_state.dart';
import 'package:taskify/features/task/data/datasources/task_firebase.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    TaskFirebase? taskFirebase,
    HiveHelper? hiveHelper,
  })  : taskFirebase = taskFirebase ?? getIt<TaskFirebase>(),
        hiveHelper = hiveHelper ?? getIt<HiveHelper>(),
        super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
    on<FilterTasks>(_onFilterTasks);
  }

  final TaskFirebase taskFirebase;
  final HiveHelper hiveHelper;
  List<Task> _allTasks = [];

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final user = hiveHelper.retrieveUserProfile();
      if (user != null) {
        _allTasks = await taskFirebase.getTasks(user.uid);
        // Clear and persist to Hive
        await hiveHelper.clearTasksBox();
        for (final task in _allTasks) {
          await hiveHelper.saveTask(task: task);
        }
      } else {
        _allTasks = await hiveHelper.getTasks();
      }
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final user = hiveHelper.retrieveUserProfile();
      if (user == null) throw Exception('User not logged in');
      final task = event.task.copyWith(
        taskId: const Uuid().v4().hashCode,
        uid: user.uid,
        email: user.email,
      );
      await taskFirebase.saveTask(task);
      _allTasks = await taskFirebase.getTasks(user.uid);
      // Clear and persist to Hive
      await hiveHelper.clearTasksBox();
      for (final task in _allTasks) {
        await hiveHelper.saveTask(task: task);
      }
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskFirebase.saveTask(event.task);
      final user = hiveHelper.retrieveUserProfile();
      if (user != null) {
        _allTasks = await taskFirebase.getTasks(user.uid);
        // Clear and persist to Hive
        await hiveHelper.clearTasksBox();
        for (final task in _allTasks) {
          await hiveHelper.saveTask(task: task);
        }
      } else {
        _allTasks = await hiveHelper.getTasks();
      }
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskFirebase.deleteTask(event.taskId.toString());
      final user = hiveHelper.retrieveUserProfile();
      if (user != null) {
        _allTasks = await taskFirebase.getTasks(user.uid);
        // Clear and persist to Hive
        await hiveHelper.clearTasksBox();
        for (final task in _allTasks) {
          await hiveHelper.saveTask(task: task);
        }
      } else {
        _allTasks = await hiveHelper.getTasks();
      }
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final query = event.query.toLowerCase();
      final filteredTasks = _allTasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList()
        // Sort alphabetically by title (A-Z)
        ..sort(
          (a, b) => a.title.toLowerCase().compareTo(
                b.title.toLowerCase(),
              ),
        );

      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      var filteredTasks = _allTasks;
      if (event.priority != null) {
        filteredTasks = filteredTasks
            .where((task) => task.priority == event.priority)
            .toList();
      }
      if (event.isDone != null) {
        filteredTasks =
            filteredTasks.where((task) => task.isDone == event.isDone).toList();
      }
      if (event.dueDate != null) {
        filteredTasks = filteredTasks.where((task) {
          final dueDate =
              DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
          final filterDate = DateTime(
            event.dueDate!.year,
            event.dueDate!.month,
            event.dueDate!.day,
          );
          return dueDate == filterDate;
        }).toList();
      }
      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
}
