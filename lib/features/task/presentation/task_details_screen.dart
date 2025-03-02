// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/share_util.dart';
import 'package:taskify/core/widgets/custom_bottom_sheet.dart';
import 'package:taskify/core/widgets/custom_button.dart';
import 'package:taskify/core/widgets/custom_container.dart';
import 'package:taskify/core/widgets/custom_outline_button.dart';
import 'package:taskify/core/widgets/custom_textfield.dart';
import 'package:taskify/core/widgets/custom_toggle.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/core/widgets/priority_selector.dart';
import 'package:taskify/core/widgets/selection_tile.dart';
import 'package:taskify/core/widgets/success_message.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_event.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_state.dart';
import 'package:taskify/features/task/data/models/task_hive.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({this.task, super.key});

  final Task? task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? dueDate;
  String priority = 'low';
  bool isDone = false;
  List<Subtask> subtasks = [];
  Task? taskToEdit;

  // Focus nodes
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  // Maps for subtask focus nodes and controllers
  final Map<int, FocusNode> subtaskFocusNodes = {};
  final Map<int, TextEditingController> subtaskControllers = {};

  void _onFocusChange() {
    setState(() {
      // Trigger rebuild
    });
  }

  @override
  void initState() {
    super.initState();

    _titleFocusNode.addListener(_onFocusChange);
    _descriptionFocusNode.addListener(_onFocusChange);
    taskToEdit = widget.task;
    if (taskToEdit != null) {
      titleController.text = taskToEdit!.title;
      descriptionController.text = taskToEdit!.description;
      startDate = taskToEdit!.startDate;
      dueDate = taskToEdit!.dueDate;
      priority = taskToEdit!.priority;
      isDone = taskToEdit!.isDone;
      subtasks = List.from(taskToEdit!.subtasks); // Create a modifiable copy
      // Initialize controllers and focus nodes for existing subtasks
      for (final subtask in subtasks) {
        subtaskControllers[subtask.id] =
            TextEditingController(text: subtask.title);
        subtaskFocusNodes[subtask.id] = FocusNode()
          ..addListener(_onFocusChange);
      }
    } else {
      startDate = DateTime.now();
      dueDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    // Remove listeners
    _titleFocusNode.removeListener(_onFocusChange);
    _descriptionFocusNode.removeListener(_onFocusChange);
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    titleController.dispose();
    descriptionController.dispose();
    // Dispose subtask focus nodes and controllers
    subtaskFocusNodes.forEach((_, focusNode) {
      focusNode
        ..removeListener(_onFocusChange)
        ..dispose();
    });
    subtaskControllers.forEach((_, controller) => controller.dispose());

    super.dispose();
  }

  void _saveTask() {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ErrorMessage.show(context, 'Enter task title and description');
      return;
    }
    final task = taskToEdit != null
        ? taskToEdit!.copyWith(
            title: titleController.text,
            description: descriptionController.text,
            startDate: startDate,
            dueDate: dueDate,
            priority: priority,
            isDone: isDone,
            subtasks: subtasks,
            synced: false, // Will be updated by TaskFirebase
          )
        : Task(
            taskId: 0, // Will be set by TaskBloc
            title: titleController.text,
            description: descriptionController.text,
            startDate: startDate!,
            dueDate: dueDate!,
            priority: priority,
            isDone: isDone,
            synced: false,
            uid: '', // Will be set by TaskBloc
            email: '',
            subtasks: subtasks,
          );
    if (taskToEdit != null) {
      context.read<TaskBloc>().add(UpdateTask(task));
    } else {
      context.read<TaskBloc>().add(AddTask(task));
    }
    Navigator.pop(context);
  }

  // Add one subtask text field and toggle
  void _addSubtask() {
    setState(() {
      final newId = subtasks.isEmpty ? 1 : subtasks.last.id + 1;
      subtasks.add(
        Subtask(
          id: newId,
          title: 'New Subtask',
          isDone: false,
        ),
      );
      subtaskControllers[newId] = TextEditingController(text: 'New Subtask');
      subtaskFocusNodes[newId] = FocusNode()..addListener(_onFocusChange);
    });
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
      ),
    );

    // Access the current theme state directly
    final isDarkTheme =
        BlocProvider.of<ThemeBloc>(context).state.themeData.brightness ==
            Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
        actions: [
          if (taskToEdit != null)
            IconButton(
              onPressed: () {
                shareUrl(
                  'Check out my next task - ${taskToEdit?.title} (${taskToEdit?.description}). Try Taskify to manage your tasks with ease.',
                );
              },
              icon: Icon(
                Icons.share_outlined,
                color: isDarkTheme ? AppColors.white : AppColors.greyDark,
              ),
            ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskFailure) {
            ErrorMessage.show(
              context,
              'Could not modify task ${state.errorMessage}',
            );
          } else if (state is TaskLoaded) {
            SuccessMessage.show(
              context,
              'Your task was saved!',
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    taskToEdit != null ? 'Edit Task' : 'Add Task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title textfield
                CustomTextField(
                  controller: titleController,
                  labelText: 'Title*',
                  prefixIcon: LineAwesomeIcons.tasks_solid,
                  focusNode: _titleFocusNode,
                  keyboardType: TextInputType.text,
                  isLoading: state is TaskLoading,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "What's the task's title?";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                // Description textfield
                CustomTextField(
                  controller: descriptionController,
                  labelText: 'Description*',
                  prefixIcon: LineAwesomeIcons.pen_fancy_solid,
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  isLoading: state is TaskLoading,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "What's the task's description?";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // start date
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: CustomContainer(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() => startDate = selectedDate);
                      }
                    },
                    title: 'Start date*',
                    displayText: startDate == null
                        ? 'Select start date'
                        : startDate!.toString().split(' ')[0],
                  ),
                ),
                // Due date
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: CustomContainer(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() => dueDate = selectedDate);
                      }
                    },
                    title: 'Due date*',
                    displayText: dueDate == null
                        ? 'Select Due Date*'
                        : dueDate!.toString().split(' ')[0],
                  ),
                ),
                // Priority
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: CustomContainer(
                    onTap: () async => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => CustomBottomSheet(
                        body: PrioritySelector(
                          selectedPriority: priority,
                          onPrioritySelected: (value) =>
                              setState(() => priority = value),
                        ),
                        scaleFactor: .6,
                        title: 'Priority',
                      ),
                    ),
                    title: 'Priority*',
                    displayText: _capitalize(priority),
                  ),
                ),
                // Complete or pending toggle
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: SelectionTile(
                    onTap: () {
                      setState(() => isDone = !isDone);
                    },
                    icon: Icon(
                      !isDone ? Icons.circle_outlined : Icons.check_circle,
                      color: AppColors.primary,
                    ),
                    customIcon: CustomToggle(
                      value: isDone,
                      onTap: () {
                        setState(() => isDone = !isDone);
                      },
                    ),
                    title: Text(
                      'Complete task',
                      style: TextStyle(
                        color:
                            isDarkTheme ? AppColors.white : AppColors.greyDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    showCustomIcon: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Divider(
                    thickness: 0.2,
                    color: isDarkTheme
                        ? AppColors.white.withValues(
                            alpha: 0.3,
                          )
                        : AppColors.greyDark.withValues(
                            alpha: 0.3,
                          ),
                  ),
                ),
                if (subtasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      'Subtasks',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                if (subtasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 20,
                      bottom: 20,
                    ),
                    child: Text(
                      'Click the toggle to complete a subtask',
                      style: TextStyle(
                        color:
                            isDarkTheme ? AppColors.white : AppColors.greyDark,
                        fontSize: 14,
                      ),
                    ),
                  ),
                // subtasks list
                if (subtasks.isNotEmpty)
                  ...subtasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final subtask = entry.value;
                    // Ensure controller and focus node exist
                    if (!subtaskControllers.containsKey(subtask.id)) {
                      subtaskControllers[subtask.id] =
                          TextEditingController(text: subtask.title);
                    }
                    if (!subtaskFocusNodes.containsKey(subtask.id)) {
                      subtaskFocusNodes[subtask.id] = FocusNode()
                        ..addListener(_onFocusChange);
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: CustomTextField(
                        controller: subtaskControllers[subtask.id]!,
                        labelText: 'Title*',
                        prefixIcon: LineAwesomeIcons.tasks_solid,
                        focusNode: subtaskFocusNodes[subtask.id]!,
                        keyboardType: TextInputType.text,
                        isLoading: state is TaskLoading,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "What's the subtask's title?";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            subtasks[index] = subtask.copyWith(title: value);
                          });
                          return '';
                        },
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: CustomToggle(
                                onTap: () {
                                  setState(() {
                                    subtasks[index] = subtask.copyWith(
                                      isDone: !subtask.isDone,
                                    );
                                  });
                                },
                                value: subtask.isDone,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Dispose controller and focus node
                                  subtaskControllers[subtask.id]?.dispose();
                                  subtaskFocusNodes[subtask.id]
                                      ?.removeListener(_onFocusChange);
                                  subtaskFocusNodes[subtask.id]?.dispose();
                                  subtaskControllers.remove(subtask.id);
                                  subtaskFocusNodes.remove(subtask.id);
                                  // Remove subtask from list
                                  subtasks.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                // Add subtask button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                  ),
                  child: CustomOutlineButton(
                    onPressed: _addSubtask,
                    isLoading: state is TaskLoading,
                    buttonColor: AppColors.success,
                    useButtonColor: true,
                    buttonText: 'Add Subtask',
                  ),
                ),
                const SizedBox(height: 20),
                // save button
                CustomButton(
                  onPressed: _saveTask,
                  buttonText: 'Save',
                  isLoading: state is TaskLoading,
                ),
                const SizedBox(height: 15),
                // Credits section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Powered by',
                      style: TextStyle(
                        color: AppColors.greyDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      AssetsPath.taskifyLogo,
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
