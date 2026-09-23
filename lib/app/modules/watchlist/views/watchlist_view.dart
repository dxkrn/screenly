import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/modules/home/controllers/home_controller.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/watchlist_controller.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.watchlistItems.isNotEmpty) {
                  return Column(
                    children: [
                      _buildFilterChips(),
                      const SizedBox(height: 12),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  backgroundColor: const Color(0xFF1E1E1E),
                  onRefresh: controller.loadBookmarks,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.watchlistItems.isEmpty) {
                      return _buildLoadingSkeleton();
                    }

                    if (controller.watchlistItems.isEmpty) {
                      return _buildEmptyState();
                    }

                    final items = controller.filteredItems;
                    if (items.isEmpty) {
                      return _buildNoFilterMatchState();
                    }

                    return _buildWatchlistGrid(items);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Watchlist',
              style: heading4TextStyle.copyWith(color: whiteColor),
            ),
          ],
        ),
        Text(
          'Your collection of saved movies and TV shows to watch',
          style: paragraphSmallTextStyle.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final currentFilter = controller.selectedFilter.value;
      final totalCount = controller.watchlistItems.length;
      final movieCount = controller.movieCount;
      final tvCount = controller.tvCount;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'All ($totalCount)',
              isSelected: currentFilter == 'all',
              onTap: () => controller.setFilter('all'),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Movies ($movieCount)',
              isSelected: currentFilter == 'movie',
              onTap: () => controller.setFilter('movie'),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'TV Shows ($tvCount)',
              isSelected: currentFilter == 'tv',
              onTap: () => controller.setFilter('tv'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: paragraphSmallTextStyle.copyWith(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlistGrid(List<SearchResultModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        final itemHeight = itemWidth * (4 / 3);

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: itemWidth / (itemHeight + 64),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final isMovie = item.isMovie || item.mediaType == 'movie';

            return isMovie
                ? MovieCard(
                    title: item.displayTitle,
                    posterUrl: item.fullPosterUrl,
                    voteAvg: item.voteAverage,
                    voteCount: item.voteCount,
                    width: itemWidth,
                    height: itemHeight,
                    showTypeBadge: true,
                    onTap: () => _navigateToDetails(item, isMovie),
                  )
                : TvshowCard(
                    title: item.displayTitle,
                    posterUrl: item.fullPosterUrl,
                    voteAvg: item.voteAverage,
                    voteCount: item.voteCount,
                    width: itemWidth,
                    height: itemHeight,
                    showTypeBadge: true,
                    onTap: () => _navigateToDetails(item, isMovie),
                  );
          },
        );
      },
    );
  }

  Future<void> _navigateToDetails(SearchResultModel item, bool isMovie) async {
    await Get.toNamed(
      Routes.DETAILS,
      arguments: {
        'id': item.id,
        'type': isMovie ? 'movie' : 'tv',
      },
    );
    controller.loadBookmarks();
  }

  Widget _buildLoadingSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;
        final itemHeight = itemWidth * (4 / 3);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
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

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                          Icons.bookmark_outline_rounded,
                          color: Colors.white38,
                          size: 42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Watchlist is Empty',
                      style: heading5TextStyle.copyWith(color: whiteColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save movies and TV shows to your watchlist by tapping the bookmark icon on their detail page.',
                      textAlign: TextAlign.center,
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.white54,
                        height: 1.5,
                      ),
                    ),
                    Obx(() {
                      if (!controller.isTmdbConnected.value) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              if (Get.isRegistered<HomeController>()) {
                                Get.find<HomeController>().changeTabIndex(3);
                              }
                            },
                            icon:
                                const Icon(Icons.cloud_sync_rounded, size: 18),
                            label: Text(
                              'Connect TMDB Account',
                              style: heading6TextStyle.copyWith(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoFilterMatchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.filter_list_off_rounded,
              color: Colors.white38,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No items match this filter',
              style: heading6TextStyle.copyWith(color: whiteColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different filter tab.',
              style: paragraphSmallTextStyle.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
