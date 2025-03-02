// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_event.dart';
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

  @override
  void initState() {
    super.initState();
    taskToEdit = widget.task;
    if (taskToEdit != null) {
      titleController.text = taskToEdit!.title;
      descriptionController.text = taskToEdit!.description;
      startDate = taskToEdit!.startDate;
      dueDate = taskToEdit!.dueDate;
      priority = taskToEdit!.priority;
      isDone = taskToEdit!.isDone;
      subtasks = taskToEdit!.subtasks;
    } else {
      startDate = DateTime.now();
      dueDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (titleController.text.isEmpty || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Due Date are required')),
      );
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

  void _addSubtask() {
    setState(() {
      subtasks.add(
        Subtask(
          id: subtasks.length + 1,
          title: 'New Subtask',
          isDone: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(taskToEdit != null ? 'Edit Task' : 'Add Task'),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title*'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      startDate == null
                          ? 'Start Date: ${DateTime.now().toString().split(' ')[0]}'
                          : 'Start: ${startDate!.toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
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
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dueDate == null
                          ? 'Select Due Date*'
                          : 'Due: ${dueDate!.toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
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
                  ),
                ],
              ),
              DropdownButton<String>(
                value: priority,
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              CheckboxListTile(
                title: const Text('Mark as Done'),
                value: isDone,
                onChanged: (value) => setState(() => isDone = value!),
              ),
              const Divider(),
              const Text(
                'Subtasks',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...subtasks.asMap().entries.map((entry) {
                final index = entry.key;
                final subtask = entry.value;
                return ListTile(
                  title: TextField(
                    controller: TextEditingController(text: subtask.title),
                    decoration:
                        const InputDecoration(hintText: 'Subtask Title'),
                    onChanged: (value) {
                      setState(() {
                        subtasks[index] = subtask.copyWith(title: value);
                      });
                    },
                  ),
                  trailing: Checkbox(
                    value: subtask.isDone,
                    onChanged: (value) {
                      setState(() {
                        subtasks[index] =
                            subtask.copyWith(isDone: value ?? false);
                      });
                    },
                  ),
                );
              }),
              TextButton(
                onPressed: _addSubtask,
                child: const Text(
                  'Add Subtask',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
