import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends StatefulWidget {
  final String? categoryType;
  final String? title;
  final String? subtitle;

  const DiscoverView({
    super.key,
    this.categoryType,
    this.title,
    this.subtitle,
  });

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  late final DiscoverController controller;
  late final String? _tag;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments is Map ? (Get.arguments as Map) : null;
    final cat = widget.categoryType ?? args?['categoryType'] as String?;
    final title = widget.title ?? args?['title'] as String?;
    final subtitle = widget.subtitle ?? args?['subtitle'] as String?;

    _tag = cat;
    if (_tag != null) {
      controller = Get.isRegistered<DiscoverController>(tag: _tag)
          ? Get.find<DiscoverController>(tag: _tag)
          : Get.put(DiscoverController(), tag: _tag);

      if (!controller.isCategoryMode.value ||
          controller.categoryType.value != _tag) {
        controller.loadCategory(
          category: _tag,
          title: title ?? 'Discover',
          subtitle: subtitle,
        );
      }
    } else {
      controller = Get.isRegistered<DiscoverController>()
          ? Get.find<DiscoverController>()
          : Get.put(DiscoverController());
    }
  }

  @override
  void dispose() {
    if (_tag != null && Get.isRegistered<DiscoverController>(tag: _tag)) {
      Get.delete<DiscoverController>(tag: _tag);
    }
    super.dispose();
  }

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
              const SizedBox(height: 12),
              _buildHeader(context),
              Obx(() {
                if (controller.isCategoryMode.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildSearchBar(controller),
                );
              }),
              const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final showBackButton = _tag != null || controller.isCategoryMode.value;

    return Row(
      children: [
        if (showBackButton) ...[
          _buildBackButton(context),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Obx(
                () => Text(
                  controller.titleText.value,
                  style: heading4TextStyle.copyWith(color: whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(
                () => Text(
                  controller.subtitleText.value,
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white70,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Get.back();
            }
          },
          child: const Center(
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
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

        return CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: itemWidth / (itemHeight + 64),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = controller.searchResults[index];
                  if (item.isMovie) {
                    return MovieCard(
                      title: item.displayTitle,
                      posterUrl: item.fullPosterUrl,
                      voteAvg: item.voteAverage,
                      voteCount: item.voteCount,
                      width: itemWidth,
                      height: itemHeight,
                      showTypeBadge: !controller.isCategoryMode.value,
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
                      showTypeBadge: !controller.isCategoryMode.value,
                      onTap: () => Get.toNamed(
                        Routes.DETAILS,
                        arguments: {'id': item.id, 'type': 'tv'},
                      ),
                    );
                  }
                },
                childCount: controller.searchResults.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoadingMore.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 24);
              }),
            ),
          ],
        );
      },
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
            controller.isCategoryMode.value
                ? 'Failed to load ${controller.titleText.value.toLowerCase()}'
                : 'Failed to search results',
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
    if (controller.isCategoryMode.value) {
      return Center(
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
                  Icons.movie_filter_rounded,
                  color: Colors.white38,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No items found',
              style: heading5TextStyle.copyWith(color: whiteColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for updates',
              textAlign: TextAlign.center,
              style: paragraphSmallTextStyle.copyWith(
                color: Colors.white54,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    if (!controller.hasSearched.value) {
      return Center(
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
                  Icons.search_rounded,
                  color: Colors.white38,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Search movies & TV shows',
              style: heading5TextStyle.copyWith(color: whiteColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Type a title and press search on your keyboard',
              textAlign: TextAlign.center,
              style: paragraphSmallTextStyle.copyWith(
                color: Colors.white54,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
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
                Icons.search_off_rounded,
                color: Colors.white38,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No results found for "${controller.lastSearchedQuery.value}"',
            style: heading5TextStyle.copyWith(color: whiteColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Try checking your spelling or use different keywords',
            textAlign: TextAlign.center,
            style: paragraphSmallTextStyle.copyWith(
              color: Colors.white54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
