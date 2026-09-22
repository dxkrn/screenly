import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenly/app/components/section_title.dart';
import 'package:screenly/app/modules/tvshow/controllers/tvshow_controller.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class TopRatedSection extends StatelessWidget {
  const TopRatedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TvshowController controller = Get.isRegistered<TvshowController>()
        ? Get.find<TvshowController>()
        : Get.put(TvshowController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        SectionTitle(
          title: 'Top Rated Shows',
          ontap: () => Get.toNamed(
            Routes.DISCOVER,
            arguments: {
              'title': 'Top Rated Shows',
              'subtitle': 'Explore the highest rated TV shows',
              'categoryType': 'tv_top_rated',
            },
          ),
        ),
        Obx(() {
          if (controller.isLoadingTopRated.value) {
            return _buildLoadingState();
          }

          if (controller.topRatedErrorMessage.isNotEmpty &&
              controller.topRatedTvShows.isEmpty) {
            return _buildErrorState(controller);
          }

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: controller.topRatedTvShows.map((tvShow) {
                  return TvshowCard(
                    title: tvShow.name,
                    posterUrl: tvShow.fullPosterUrl,
                    voteAvg: tvShow.voteAverage,
                    voteCount: tvShow.voteCount,
                    onTap: () => Get.toNamed(
                      Routes.DETAILS,
                      arguments: {'id': tvShow.id, 'type': 'tv'},
                    ),
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
              'Failed to load top rated shows',
              style: paragraphSmallTextStyle.copyWith(
                color: whiteColor,
                fontSize: 13.sp,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () => controller.fetchTopRatedTvShows(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retry',
                style: heading6TextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
