import 'package:flutter/material.dart';
import 'package:taskify/core/utils/app_colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(
            alpha: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.5,
              ),
              blurRadius: 12,
              spreadRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          border: Border.fromBorderSide(
            BorderSide(
              width: 0.1,
              color: AppColors.primary.withValues(
                alpha: 0.5,
              ),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //leading icon
            leadingIcon,
            // title and trailing icon
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.primary,
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
      ),
    );
  }
}
