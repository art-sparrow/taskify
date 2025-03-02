import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_state.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({
    required this.title,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.trailing,
    required this.onTap,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final bool trailing;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        // Switch color based on theme
        final isDarkTheme = state.themeData.brightness == Brightness.dark;
        return GestureDetector(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //leading icon
              CircleAvatar(
                backgroundColor: isDarkTheme
                    ? AppColors.white.withValues(
                        alpha: 0.1,
                      )
                    : AppColors.greyDark.withValues(
                        alpha: 0.1,
                      ),
                child: leadingIcon,
              ),
              // title and trailing icon
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isDarkTheme
                              ? AppColors.white
                              : AppColors.greyDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (trailing) trailingIcon,
                      if (isLoading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
