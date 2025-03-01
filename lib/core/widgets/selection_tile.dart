// ignore_for_file: prefer_const_constructors, file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/utils/app_colors.dart';

class SelectionTile extends StatelessWidget {
  const SelectionTile({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.showCustomIcon,
    this.customIcon = const Icon(
      LineAwesomeIcons.angle_right_solid,
      color: AppColors.transparent,
    ),
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final Icon icon;
  final Text title;
  final Widget customIcon;
  final bool showCustomIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          if (!showCustomIcon) icon else customIcon,
        ],
      ),
    );
  }
}
