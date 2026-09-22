import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class DisconnectDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DisconnectDialog({
    super.key,
    required this.onConfirm,
  });

  static void show(BuildContext context, {required VoidCallback onConfirm}) {
    Get.dialog(
      DisconnectDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Disconnect TMDB Account?',
        style: heading5TextStyle.copyWith(color: whiteColor),
      ),
      content: Text(
        'This will remove your TMDB session. Your locally cached watchlist will remain available on this device.',
        style: paragraphSmallTextStyle.copyWith(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: paragraphRegulerTextStyle.copyWith(color: Colors.white60),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Get.back();
            onConfirm();
          },
          child: const Text('Disconnect'),
        ),
      ],
    );
  }
}
