import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_state.dart';

class CustomContainer extends StatefulWidget {
  const CustomContainer({
    required this.onTap,
    required this.title,
    required this.displayText,
    super.key,
  });

  final VoidCallback onTap;
  final String title;
  final String displayText;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    // Access the current theme state directly
    final isDarkTheme =
        BlocProvider.of<ThemeBloc>(context).state.themeData.brightness ==
            Brightness.dark;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkTheme ? AppColors.black : AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: isDarkTheme
                                ? AppColors.greyDark
                                : AppColors.greyDark,
                            width: 0.6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.displayText,
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.greyDark
                                  : AppColors.greyDark,
                              fontSize: 16,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 2,
                              right: 2,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -9,
                      left: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkTheme ? AppColors.black : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ' ${widget.title} ',
                          style: TextStyle(
                            color: isDarkTheme
                                ? AppColors.greyDark
                                : AppColors.greyDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
