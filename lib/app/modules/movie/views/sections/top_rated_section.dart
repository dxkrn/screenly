import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenly/app/components/section_title.dart';
import 'package:screenly/app/modules/movie/controllers/movie_controller.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../components/movie_card.dart';

class TopRatedSection extends StatelessWidget {
  const TopRatedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.isRegistered<MovieController>()
        ? Get.find<MovieController>()
        : Get.put(MovieController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        SectionTitle(
          title: 'Top Rated Movies',
          ontap: () => Get.toNamed(
            Routes.DISCOVER,
            arguments: {
              'title': 'Top Rated Movies',
              'subtitle': 'Explore the all-time highest rated movies',
              'categoryType': 'movie_top_rated',
            },
          ),
        ),
        Obx(() {
          if (controller.isLoadingTopRated.value) {
            return _buildLoadingState();
          }

          if (controller.topRatedErrorMessage.isNotEmpty &&
              controller.topRatedMovies.isEmpty) {
            return _buildErrorState(controller);
          }

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: controller.topRatedMovies.map((movie) {
                  return MovieCard(
                    title: movie.title,
                    posterUrl: movie.fullPosterUrl,
                    voteAvg: movie.voteAverage,
                    voteCount: movie.voteCount,
                    onTap: () => Get.toNamed(
                      Routes.DETAILS,
                      arguments: {'id': movie.id, 'type': 'movie'},
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
            (index) => const MovieCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(MovieController controller) {
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
              'Failed to load top rated movies',
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
              onPressed: () => controller.fetchTopRatedMovies(),
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
