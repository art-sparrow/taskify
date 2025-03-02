import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/features/profile/blocs/theme_bloc/theme_bloc.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    required this.body,
    required this.scaleFactor,
    required this.title,
    this.subTitle = '',
    super.key,
  });

  final Widget body;
  final double scaleFactor;
  final String title;
  final String subTitle;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme state directly
    final isDarkTheme =
        BlocProvider.of<ThemeBloc>(context).state.themeData.brightness ==
            Brightness.dark;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * widget.scaleFactor,
      decoration: BoxDecoration(
        color: isDarkTheme ? AppColors.black : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(27),
          topRight: Radius.circular(27),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(27),
                topRight: Radius.circular(27),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Center(
                  child: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppColors.white),
                  ),
                ),
                const SizedBox(
                  height: 28,
                  width: 28,
                ),
              ],
            ),
          ),
          if (widget.subTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 20,
                bottom: 20,
              ),
              child: Text(
                widget.subTitle,
                style: TextStyle(
                  color: isDarkTheme ? AppColors.white : AppColors.greyDark,
                  fontSize: 14,
                ),
              ),
            ),
          widget.body,
        ],
      ),
    );
  }
}
