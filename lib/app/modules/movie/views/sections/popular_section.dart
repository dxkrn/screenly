import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/movie/controllers/movie_controller.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../components/movie_card.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.isRegistered<MovieController>()
        ? Get.find<MovieController>()
        : Get.put(MovieController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Movies',
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
        ),
        Obx(() {
          if (controller.isLoadingPopular.value) {
            return _buildLoadingState();
          }

          if (controller.popularErrorMessage.isNotEmpty &&
              controller.popularMovies.isEmpty) {
            return _buildErrorState(controller);
          }

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 12,
                children: controller.popularMovies.map((movie) {
                  return MovieCard(
                    title: movie.title,
                    posterUrl: movie.fullPosterUrl,
                    voteAvg: movie.voteAverage,
                    voteCount: movie.voteCount,
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
              'Failed to load popular movies',
              style: heading6TextStyle.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => controller.fetchPopularMovies(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Retry',
                style: paragraphSmallTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
