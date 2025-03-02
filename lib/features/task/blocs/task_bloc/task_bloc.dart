import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/core/services/internet_service.dart';
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
    on<SyncTasks>(_onSyncTasks);
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
      var filteredTasks = List<Task>.from(_allTasks);
      // Apply filters
      if (event.priority != null) {
        filteredTasks = filteredTasks
            .where(
              (task) => task.priority == event.priority,
            )
            .toList();
        // Sort by priority if specified
        const priorityOrderAsc = {'low': 1, 'medium': 2, 'high': 3};
        const priorityOrderDesc = {'low': 3, 'medium': 2, 'high': 1};
        if (event.priority == 'ascending') {
          filteredTasks.sort(
            (a, b) => priorityOrderAsc[a.priority]!.compareTo(
              priorityOrderAsc[b.priority]!,
            ),
          );
        } else if (event.priority == 'descending') {
          filteredTasks.sort(
            (a, b) => priorityOrderDesc[a.priority]!.compareTo(
              priorityOrderDesc[b.priority]!,
            ),
          );
        }
      }
      if (event.isDone != null) {
        filteredTasks = filteredTasks
            .where(
              (task) => task.isDone == event.isDone,
            )
            .toList();
        // Sort by isDone (true/false)
        if (event.isDone! == true) {
          filteredTasks.sort((a, b) => b.isDone ? 1 : -1);
        } else {
          filteredTasks.sort((a, b) => a.isDone ? 1 : -1);
        }
      }
      if (event.dueDate != null) {
        filteredTasks = filteredTasks.where((task) {
          final dueDate = DateTime(
            task.dueDate.year,
            task.dueDate.month,
            task.dueDate.day,
          );
          final filterDate = DateTime(
            event.dueDate!.year,
            event.dueDate!.month,
            event.dueDate!.day,
          );
          return dueDate == filterDate;
        }).toList();
        // Sort by dueDate
        if (event.dueDate == DateTime(1970)) {
          // Placeholder for ascending
          filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        } else if (event.dueDate == DateTime(1971)) {
          // Placeholder for descending
          filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        }
      }
      // Always sort A-Z as default after filters
      filteredTasks.sort(
        (a, b) => a.title.toLowerCase().compareTo(
              b.title.toLowerCase(),
            ),
      );
      emit(TaskLoaded(filteredTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }

  Future<void> _onSyncTasks(
    SyncTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      // Fetch tasks with synced: false from Hive
      final unsyncedTasks = await hiveHelper.getTasks();
      final tasksToSync = unsyncedTasks.where((task) => !task.synced).toList();

      if (tasksToSync.isNotEmpty) {
        // Sync each task to Firestore
        for (final task in tasksToSync) {
          // Update the task in Firestore
          await taskFirebase.saveTask(task);
        }
      }

      // Check internet connectivity
      final hasInternet = await InternetService.check();

      // Refresh the task list
      final user = hiveHelper.retrieveUserProfile();
      if (hasInternet) {
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
      } else {
        _allTasks = await hiveHelper.getTasks();
      }
      emit(TaskLoaded(_allTasks));
    } catch (e) {
      emit(TaskFailure(e.toString()));
    }
  }
}
