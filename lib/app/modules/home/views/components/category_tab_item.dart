import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class CategoryTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback onTap;

  const CategoryTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.isAvailable = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isAvailable
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (isAvailable
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: paragraphSmallTextStyle.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.black
                    : (isAvailable
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5)),
              ),
            ),
            if (!isAvailable) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withValues(alpha: 0.15)
                      : primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? Colors.black.withValues(alpha: 0.3)
                        : primaryColor.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'Soon',
                  style: paragraphSmallTextStyle.copyWith(
                    fontSize: 8,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.black : primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
