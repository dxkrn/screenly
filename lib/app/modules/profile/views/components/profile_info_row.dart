import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white54),
        const SizedBox(width: 10),
        Text(
          label,
          style: paragraphSmallTextStyle.copyWith(color: Colors.white60),
        ),
        const Spacer(),
        Text(
          value,
          style: paragraphSmallTextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
