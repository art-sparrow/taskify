// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:taskify/core/constants/assets_path.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final RegistrationEntity? user;
  late List<Task> localTasks = [];
  final _logger = Logger();
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> taskDates = [];
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    user = getIt<HiveHelper>().retrieveUserProfile();
    if (user == null) {
      _logger.e('No user found in Hive—redirecting to login');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, TaskifyRouter.logInScreenRoute);
      });
    }
    _fetchTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    localTasks = await getIt<HiveHelper>().getTasks();
    if (localTasks.isEmpty && mounted) {
      context.read<TaskBloc>().add(LoadTasks());
    }
    _updateTaskDates();
  }

  void _updateTaskDates() {
    taskDates = localTasks.map((task) => task.dueDate).toList();
  }

  Widget _buildDayInitialCell(String dayInitial) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        dayInitial,
        style: const TextStyle(fontSize: 16, color: AppColors.greyDark),
      ),
    );
  }

  Widget _buildCalendarCell(DateTime dateTime, int? day) {
    if (day == null) return Container();

    final cellDate = DateTime(dateTime.year, dateTime.month, day);
    final isCurrentDay = _selectedDate.year == cellDate.year &&
        _selectedDate.month == cellDate.month &&
        _selectedDate.day == cellDate.day;
    final isTaskDay = taskDates.any(
      (taskDate) =>
          taskDate.year == cellDate.year &&
          taskDate.month == cellDate.month &&
          taskDate.day == cellDate.day,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = cellDate;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrentDay
              ? AppColors.primary
              : isTaskDay
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.transparent,
        ),
        child: Text(
          day.toString(),
          style: TextStyle(
            fontSize: 16,
            color: isCurrentDay || isTaskDay
                ? AppColors.white
                : AppColors.greyDark,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime dateTime) {
    final daysInMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    var firstWeekDay = DateTime(dateTime.year, dateTime.month).weekday;
    firstWeekDay = firstWeekDay == 7 ? 1 : firstWeekDay + 1;

    final calendarDays = <List<int?>>[];
    var currentWeek = <int?>[];
    var currentDay = 1;

    for (var i = 1; i < firstWeekDay; i++) {
      currentWeek.add(null);
    }

    for (var i = 1; i <= daysInMonth; i++) {
      currentWeek.add(currentDay);
      currentDay++;
      if (currentWeek.length == 7) {
        calendarDays.add(currentWeek);
        currentWeek = [];
      }
    }

    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      calendarDays.add(currentWeek);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _currentMonth =
                      DateTime(_currentMonth.year, _currentMonth.month - 1);
                });
              },
            ),
            Text(
              '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _currentMonth =
                      DateTime(_currentMonth.year, _currentMonth.month + 1);
                });
              },
            ),
          ],
        ),
        Table(
          children: [
            TableRow(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(_buildDayInitialCell)
                  .toList(),
            ),
            ...calendarDays.map(
              (week) => TableRow(
                children: week
                    .map((day) => _buildCalendarCell(_currentMonth, day))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColors.transparent),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            backgroundColor: AppColors.transparent,
            radius: 10,
            backgroundImage: AssetImage(AssetsPath.profilePicture),
          ),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Text(
                'Hello! 👋',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: AppColors.greyDark,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                user?.name ?? 'Username',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                TaskifyRouter.notificationsScreenRoute,
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Stack(
                children: [
                  Icon(LineAwesomeIcons.bell_solid),
                  Positioned(
                    top: 0,
                    right: 6,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskFailure) {
                ErrorMessage.show(context, state.errorMessage);
              }
              if (state is TaskLoaded) {
                localTasks = state.tasks;
                _updateTaskDates();
              }
            },
            builder: (context, state) {
              if (state is TaskLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height -
                      100, // Adjust for AppBar and padding
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              final tasks = state is TaskLoaded ? state.tasks : localTasks;
              final selectedDateTasks = tasks
                  .where((task) {
                    final taskDueDate = DateTime(
                      task.dueDate.year,
                      task.dueDate.month,
                      task.dueDate.day,
                    );
                    final selected = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    return taskDueDate == selected;
                  })
                  .toList()
                  .take(3)
                  .toList();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCalendar(_currentMonth),
                  const SizedBox(height: 20),
                  Text(
                    'Tasks for ${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedDateTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No tasks found - add one!',
                        style: TextStyle(
                          color: AppColors.greyDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  if (selectedDateTasks.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedDateTasks.length,
                      itemBuilder: (context, index) {
                        final task = selectedDateTasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      AppColors.primary.withValues(alpha: 0.2),
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
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                          margin: const EdgeInsets.only(top: 4),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: task.isDone
                                                ? AppColors.success
                                                    .withValues(alpha: 0.2)
                                                : AppColors.warning
                                                    .withValues(alpha: 0.2),
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                          ),
                                          onPressed: () => context
                                              .read<TaskBloc>()
                                              .add(DeleteTask(task.taskId)),
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            color: AppColors.success,
                                          ),
                                          onPressed: () async {
                                            await Navigator.pushNamed(
                                              context,
                                              TaskifyRouter
                                                  .taskDetailsScreenRoute,
                                              arguments: {'task': task},
                                            );
                                          },
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
