import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/tvshow/controllers/tvshow_controller.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class AiringTodaySection extends StatelessWidget {
  const AiringTodaySection({super.key});

  @override
  Widget build(BuildContext context) {
    final TvshowController controller = Get.isRegistered<TvshowController>()
        ? Get.find<TvshowController>()
        : Get.put(TvshowController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Airing Today Shows',
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
        ),
        Obx(() {
          if (controller.isLoadingAiringToday.value) {
            return _buildLoadingState();
          }

          if (controller.airingTodayErrorMessage.isNotEmpty &&
              controller.airingTodayTvShows.isEmpty) {
            return _buildErrorState(controller);
          }

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: controller.airingTodayTvShows.map((tvShow) {
                  return TvshowCard(
                    title: tvShow.name,
                    posterUrl: tvShow.fullPosterUrl,
                    voteAvg: tvShow.voteAverage,
                    voteCount: tvShow.voteCount,
                    onTap: () {
                      // Note: detail action
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 12,
          children: List.generate(
            5,
            (index) => const TvshowCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(TvshowController controller) {
    return Container(
      width: double.infinity,
      height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white38,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'Failed to load airing today shows',
              style: paragraphSmallTextStyle.copyWith(
                color: whiteColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () => controller.fetchAiringTodayTvShows(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retry',
                style: heading6TextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
