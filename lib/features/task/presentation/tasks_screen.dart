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
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ],
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
                const SizedBox(height: 20),
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
                            return ListTile(
                              title: Text(
                                task.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: task.isDone
                                          ? AppColors.greyDark
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                              subtitle: Text(
                                'Due: ${task.dueDate.toString().split(' ')[0]}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged: (value) {
                                  final updatedTask =
                                      task.copyWith(isDone: value ?? false);
                                  context
                                      .read<TaskBloc>()
                                      .add(UpdateTask(updatedTask));
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                ),
                                onPressed: () => context.read<TaskBloc>().add(
                                      DeleteTask(
                                        task.taskId,
                                      ),
                                    ),
                              ),
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  TaskifyRouter.taskDetailsScreenRoute,
                                  arguments: {
                                    'task': task,
                                  },
                                );
                              },
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
