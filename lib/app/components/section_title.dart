import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {super.key,
      required this.title,
      this.actionLabel,
      this.showAction = true,
      this.ontap});

  final String title;
  final String? actionLabel;
  final bool showAction;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
          if (showAction)
            GestureDetector(
              onTap: ontap,
              child: Text(
                actionLabel ?? 'See All',
                style: paragraphRegulerTextStyle.copyWith(color: whiteColor),
              ),
            ),
        ],
      ),
    );
  }
}
