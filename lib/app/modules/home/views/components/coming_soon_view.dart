import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import 'package:screenly/utils/extensions/space_extension.dart';

class ComingSoonView extends StatelessWidget {
  final String title;

  const ComingSoonView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.access_time_rounded,
                  color: Colors.white38,
                  size: 42,
                ),
              ),
            ),
            8.height,
            Text(
              'Coming Soon',
              style: heading4TextStyle.copyWith(color: whiteColor),
            ),
            4.height,
            Text(
              "Oh Sorry, we are still preparing exciting content for this category.",
              textAlign: TextAlign.center,
              style: paragraphRegulerTextStyle.copyWith(
                color: Colors.white60,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
