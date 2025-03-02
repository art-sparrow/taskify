import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/widgets/custom_toggle.dart';
import 'package:taskify/core/widgets/selection_tile.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';

class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    required this.selectedPriority,
    required this.onPrioritySelected,
    super.key,
  });

  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  @override
  Widget build(BuildContext context) {
    final priorities = ['low', 'medium', 'high'];
    return Column(
      children: priorities.map((p) {
        final isSelected = selectedPriority == p;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SelectionTile(
            onTap: () {
              onPrioritySelected(p);
              Navigator.pop(context);
            },
            icon: Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: AppColors.primary,
            ),
            customIcon: CustomToggle(
              value: isSelected,
              onTap: () {
                onPrioritySelected(p);
                Navigator.pop(context);
              },
            ),
            title: Text(
              p,
              style: TextStyle(
                color:
                    isDarkTheme(context) ? AppColors.white : AppColors.greyDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            showCustomIcon: true,
          ),
        );
      }).toList(),
    );
  }

  bool isDarkTheme(BuildContext context) =>
      context.watch<ThemeBloc>().state.themeData.brightness == Brightness.dark;
}
