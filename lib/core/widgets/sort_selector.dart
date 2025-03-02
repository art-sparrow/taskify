import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/widgets/custom_toggle.dart';
import 'package:taskify/core/widgets/selection_tile.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_bloc.dart';
import 'package:taskify/features/task/blocs/task_bloc/task_event.dart';

class SortSelector extends StatelessWidget {
  const SortSelector({
    required this.selectedSortOption,
    required this.onSortOptionSelected,
    super.key,
  });

  final String selectedSortOption;
  final ValueChanged<String> onSortOptionSelected;

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'label': 'Priority (Low to High)', 'value': 'priorityAsc'},
      {'label': 'Priority (High to Low)', 'value': 'priorityDesc'},
      {'label': 'Done First', 'value': 'doneFirst'},
      {'label': 'Pending First', 'value': 'pendingFirst'},
      {'label': 'Due Date (Ascending)', 'value': 'dueDateAsc'},
      {'label': 'Due Date (Descending)', 'value': 'dueDateDesc'},
    ];

    // Use MediaQuery to get the safe area and constrain height
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height * 0.6;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: availableHeight - mediaQuery.padding.bottom,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reset Filters Option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SelectionTile(
                onTap: () {
                  context.read<TaskBloc>().add(LoadTasks());
                  onSortOptionSelected('');
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.greyDark,
                ),
                customIcon: const SizedBox.shrink(),
                title: Text(
                  'Reset Filters',
                  style: TextStyle(
                    color: isDarkTheme(context)
                        ? AppColors.white
                        : AppColors.greyDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                showCustomIcon: false,
              ),
            ),
            // Sort options
            ...sortOptions.map((option) {
              final isSelected = selectedSortOption == option['value'];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SelectionTile(
                  onTap: () {
                    onSortOptionSelected(option['value']!);
                    if (option['value'] == 'priorityAsc') {
                      context
                          .read<TaskBloc>()
                          .add(const FilterTasks(priority: 'ascending'));
                    } else if (option['value'] == 'priorityDesc') {
                      context
                          .read<TaskBloc>()
                          .add(const FilterTasks(priority: 'descending'));
                    } else if (option['value'] == 'doneFirst') {
                      context
                          .read<TaskBloc>()
                          .add(const FilterTasks(isDone: true));
                    } else if (option['value'] == 'pendingFirst') {
                      context
                          .read<TaskBloc>()
                          .add(const FilterTasks(isDone: false));
                    } else if (option['value'] == 'dueDateAsc') {
                      context
                          .read<TaskBloc>()
                          .add(FilterTasks(dueDate: DateTime(1970)));
                    } else if (option['value'] == 'dueDateDesc') {
                      context
                          .read<TaskBloc>()
                          .add(FilterTasks(dueDate: DateTime(1971)));
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: AppColors.primary,
                  ),
                  customIcon: CustomToggle(
                    value: isSelected,
                    onTap: () {
                      onSortOptionSelected(option['value']!);
                      if (option['value'] == 'priorityAsc') {
                        context
                            .read<TaskBloc>()
                            .add(const FilterTasks(priority: 'ascending'));
                      } else if (option['value'] == 'priorityDesc') {
                        context
                            .read<TaskBloc>()
                            .add(const FilterTasks(priority: 'descending'));
                      } else if (option['value'] == 'doneFirst') {
                        context
                            .read<TaskBloc>()
                            .add(const FilterTasks(isDone: true));
                      } else if (option['value'] == 'pendingFirst') {
                        context
                            .read<TaskBloc>()
                            .add(const FilterTasks(isDone: false));
                      } else if (option['value'] == 'dueDateAsc') {
                        context
                            .read<TaskBloc>()
                            .add(FilterTasks(dueDate: DateTime(1970)));
                      } else if (option['value'] == 'dueDateDesc') {
                        context
                            .read<TaskBloc>()
                            .add(FilterTasks(dueDate: DateTime(1971)));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    option['label']!,
                    style: TextStyle(
                      color: isDarkTheme(context)
                          ? AppColors.white
                          : AppColors.greyDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showCustomIcon: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  bool isDarkTheme(BuildContext context) =>
      context.watch<ThemeBloc>().state.themeData.brightness == Brightness.dark;
}
