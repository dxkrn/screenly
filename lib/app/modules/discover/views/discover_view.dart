import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscoverController controller = Get.isRegistered<DiscoverController>()
        ? Get.find<DiscoverController>()
        : Get.put(DiscoverController());

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Discover',
                  style: heading4TextStyle.copyWith(color: whiteColor),
                ),
                Text(
                  'Find and explore your favorite movies and TV shows',
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            _buildSearchBar(controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.searchResults.isEmpty) {
                  return _buildLoadingSkeleton();
                }

                if (controller.errorMessage.isNotEmpty &&
                    controller.searchResults.isEmpty) {
                  return _buildErrorState(controller);
                }

                if (controller.searchResults.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return _buildResultsGrid(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(DiscoverController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller.searchInputController,
        textInputAction: TextInputAction.search,
        onChanged: controller.onSearchChanged,
        onSubmitted: (val) => controller.fetchSearchMulti(val),
        style: paragraphSmallTextStyle.copyWith(color: whiteColor),
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: 'Search movies and tv shows..',
          hintStyle: paragraphSmallTextStyle.copyWith(color: Colors.white38),
          prefixIcon: IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: primaryColor,
              size: 22,
            ),
            onPressed: () => controller
                .fetchSearchMulti(controller.searchInputController.text),
          ),
          suffixIcon: Obx(() {
            if (controller.searchInputText.isNotEmpty) {
              return IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildResultsGrid(DiscoverController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        final itemHeight = itemWidth * (4 / 3);

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: controller.searchResults.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: itemWidth / (itemHeight + 64),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = controller.searchResults[index];
            if (item.isMovie) {
              return MovieCard(
                title: item.displayTitle,
                posterUrl: item.fullPosterUrl,
                voteAvg: item.voteAverage,
                voteCount: item.voteCount,
                width: itemWidth,
                height: itemHeight,
                showTypeBadge: true,
                onTap: () => Get.toNamed(
                  Routes.DETAILS,
                  arguments: {'id': item.id, 'type': 'movie'},
                ),
              );
            } else {
              return TvshowCard(
                title: item.displayTitle,
                posterUrl: item.fullPosterUrl,
                voteAvg: item.voteAverage,
                voteCount: item.voteCount,
                width: itemWidth,
                height: itemHeight,
                showTypeBadge: true,
                onTap: () => Get.toNamed(
                  Routes.DETAILS,
                  arguments: {'id': item.id, 'type': 'tv'},
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildNonMovieCard(
    SearchResultModel item,
    double cardWidth,
    double cardHeight,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.DETAILS,
        arguments: {'id': item.id, 'type': item.mediaType ?? 'tv'},
      ),
      child: SizedBox(
        width: cardWidth,
        child: Column(
          spacing: 8,
          children: [
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  item.displayTitle,
                  textAlign: TextAlign.center,
                  style: paragraphSmallTextStyle.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        final itemHeight = itemWidth * (4 / 3);

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: itemWidth / (itemHeight + 64),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) => MovieCard(
            width: itemWidth,
            height: itemHeight,
          ),
        );
      },
    );
  }

  Widget _buildErrorState(DiscoverController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: Colors.white38,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to search results',
            style: heading6TextStyle.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: controller.retry,
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
    );
  }

  Widget _buildEmptyState(DiscoverController controller) {
    if (!controller.hasSearched.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_rounded,
              color: Colors.white24,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              'Search movies & TV shows',
              style: heading6TextStyle.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 6),
            Text(
              'Type a title and press search on your keyboard',
              textAlign: TextAlign.center,
              style: paragraphSmallTextStyle.copyWith(color: Colors.white38),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: Colors.white24,
            size: 56,
          ),
          const SizedBox(height: 12),
          Text(
            'No results found for "${controller.lastSearchedQuery.value}"',
            textAlign: TextAlign.center,
            style: paragraphSmallTextStyle.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Try checking your spelling or use different keywords',
            textAlign: TextAlign.center,
            style: paragraphSmallTextStyle.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
