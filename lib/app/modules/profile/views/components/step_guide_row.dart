import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class StepGuideRow extends StatelessWidget {
  final String number;
  final String text;

  const StepGuideRow({
    super.key,
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: paragraphSmallTextStyle.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: paragraphSmallTextStyle.copyWith(
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
