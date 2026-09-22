import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../../controllers/profile_controller.dart';
import '../components/step_guide_row.dart';

class WebAuthSection extends GetView<ProfileController> {
  const WebAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Card
        Container(
          padding: const EdgeInsets.all(22),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       primaryColor.withValues(alpha: 0.18),
          //       const Color(0xFF1E1E1E),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withValues(alpha: 0.3),
          //       blurRadius: 16,
          //       offset: const Offset(0, 4),
          //     ),
          //   ],
          // ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.movie_filter_rounded,
                  color: primaryColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Connect TMDB Account',
                style: heading5TextStyle.copyWith(color: whiteColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Authorize Screenly to access your TMDB account. You will be redirected to the official TMDB website to approve access.',
                style: paragraphSmallTextStyle.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Steps Breakdown Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How it works',
                style: heading6TextStyle.copyWith(
                  color: whiteColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              const StepGuideRow(
                number: '1',
                text: 'Tap "Authorize via TMDB Website" below',
              ),
              const SizedBox(height: 12),
              const StepGuideRow(
                number: '2',
                text: 'Log into TMDB in your browser and click "Approve"',
              ),
              const SizedBox(height: 12),
              const StepGuideRow(
                number: '3',
                text:
                    'TMDB will automatically redirect you back here to finish login!',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Primary Action: Open Browser
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
                controller.isLoading.value ? null : controller.startWebAuth,
            icon: controller.isLoading.value
                ? const SizedBox.shrink()
                : const Icon(Icons.open_in_new_rounded, size: 20),
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
                    'Authorize via TMDB Website',
                    style: heading6TextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 20),

        // TMDB registration hint
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white54,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Don\'t have a TMDB account yet? Create one for free at themoviedb.org',
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
