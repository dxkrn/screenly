import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../../controllers/profile_controller.dart';

class AwaitingApprovalSection extends GetView<ProfileController> {
  const AwaitingApprovalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Waiting for Approval',
                style: heading5TextStyle.copyWith(color: whiteColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We have opened themoviedb.org in your browser.\nOnce you click "Approve" on TMDB, you will be automatically returned to Screenly. You can also tap the button below if redirect does not happen automatically.',
                style: paragraphSmallTextStyle.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Confirm button
        Obx(
          () => ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed:
                controller.isLoading.value ? null : controller.completeWebAuth,
            icon: controller.isLoading.value
                ? const SizedBox.shrink()
                : const Icon(Icons.check_circle_rounded, size: 20),
            label: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    'I Have Approved (Complete Login)',
                    style: heading6TextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary actions: Re-open browser or cancel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: controller.reopenAuthUrl,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 16,
                color: Colors.white70,
              ),
              label: Text(
                'Reopen Browser',
                style: paragraphSmallTextStyle.copyWith(color: Colors.white70),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '•',
              style: paragraphSmallTextStyle.copyWith(color: Colors.white38),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: controller.cancelWebAuth,
              icon: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.redAccent,
              ),
              label: Text(
                'Cancel',
                style:
                    paragraphSmallTextStyle.copyWith(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
