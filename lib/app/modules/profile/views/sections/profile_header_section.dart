import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'Profile',
          style: heading4TextStyle.copyWith(color: whiteColor),
        ),
        Text(
          'Manage your TMDB account & synchronization',
          style: paragraphSmallTextStyle.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
