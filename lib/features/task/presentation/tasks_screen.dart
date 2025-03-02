// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:taskify/core/helpers/hive_helper.dart';
import 'package:taskify/core/helpers/service_locator.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/features/auth/data/models/register_hive.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_event.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_state.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final RegistrationEntity? user;
  late List<Task> localTasks = [];
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    // Fetch user
    user = getIt<HiveHelper>().retrieveUserProfile();
    if (user == null) {
      // Redirect to login if no user
      _logger.e('No user found in Hive—redirecting to login');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, TaskifyRouter.logInScreenRoute);
      });
    }
    // Fetch Tasks
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    // Fetch from local storage first
    localTasks = await getIt<HiveHelper>().getTasks();
    // Fetch from Firestore if localTasks is empty
    if (localTasks.isEmpty) {
      if (mounted) {
        context.read<TaskBloc>().add(LoadTasks());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
      ),
    );

    return Scaffold(
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskFailure) {
            ErrorMessage.show(context, state.errorMessage);
          }
          if (state is TaskLoaded) {
            localTasks = state.tasks;
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ],
              ),
            );
          }

          final tasks = state is TaskLoaded ? state.tasks : localTasks;

          return Padding(
            padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          TaskifyRouter.taskDetailsScreenRoute,
                          arguments: {
                            'task': null,
                          },
                        );
                      },
                      child: const Text(
                        'Add tasks',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Tasks list view
                Flexible(
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text(
                            'No tasks yet - add one!',
                            style: TextStyle(
                              color: AppColors.greyDark,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    child: Text(
                                      task.title.substring(0, 1),
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Task name, due date, and status
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            task.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        Text(
                                          'Due: ${task.dueDate.toString().split(' ')[0]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Container(
                                          height: 20,
                                          width: 80,
                                          margin: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: task.isDone
                                                ? AppColors.success.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : AppColors.warning.withValues(
                                                    alpha: 0.2,
                                                  ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: Text(
                                            task.isDone
                                                ? 'Complete'
                                                : 'Pending',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: task.isDone
                                                      ? AppColors.success
                                                      : AppColors.warning,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // delete task
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 60,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.error,
                                        ),
                                        onPressed: () =>
                                            context.read<TaskBloc>().add(
                                                  DeleteTask(
                                                    task.taskId,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    // edit task
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.success,
                                      ),
                                      onPressed: () async {
                                        await Navigator.pushNamed(
                                          context,
                                          TaskifyRouter.taskDetailsScreenRoute,
                                          arguments: {
                                            'task': task,
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
