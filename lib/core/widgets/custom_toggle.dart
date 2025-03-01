// ignore_for_file: prefer_const_constructors, file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'package:taskify/core/utils/app_colors.dart';

class CustomToggle extends StatelessWidget {
  const CustomToggle({
    required this.onTap,
    required this.value,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 40,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: value,
          onChanged: (bool value) async {
            onTap();
          },
          activeColor: AppColors.primary,
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primary.withValues(
            alpha: 0.1,
          ),
          thumbColor: const WidgetStatePropertyAll<Color>(
            AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}
