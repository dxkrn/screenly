import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/tvshow/controllers/tvshow_controller.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class OnTheAirSection extends StatelessWidget {
  const OnTheAirSection({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'On The Air',
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
        ),
        Obx(() {
          if (controller.isLoadingOnTheAir.value) {
            return _buildLoadingState();
          }

          if (controller.onTheAirErrorMessage.isNotEmpty &&
              controller.onTheAirTvShows.isEmpty) {
            return _buildErrorState(controller);
          }

          return FlutterCarousel(
            options: FlutterCarouselOptions(
              height: 440,
              showIndicator: true,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              enlargeFactor: 96 / 440,
              viewportFraction: 0.85,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              slideIndicator: CircularSlideIndicator(
                slideIndicatorOptions: SlideIndicatorOptions(
                  indicatorRadius: 4,
                  itemSpacing: 12,
                  currentIndicatorColor: primaryColor,
                  indicatorBackgroundColor: Colors.grey.withValues(alpha: 0.5),
                ),
              ),
            ),
            items: controller.onTheAirTvShows.map((tvShow) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      Routes.DETAILS,
                      arguments: {'id': tvShow.id, 'type': 'tv'},
                    ),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // NOTE: Poster Image
                          if (tvShow.fullPosterUrl.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: tvShow.fullPosterUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFF1E1E1E),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFF1E1E1E),
                                child: const Icon(
                                  Icons.tv_rounded,
                                  color: Colors.white38,
                                  size: 48,
                                ),
                              ),
                            )
                          else
                            Container(
                              color: const Color(0xFF1E1E1E),
                              child: const Icon(
                                Icons.tv_rounded,
                                color: Colors.white38,
                                size: 48,
                              ),
                            ),

                          // NOTE: Gradient Shadow at bottom
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.3),
                                    Colors.black.withValues(alpha: 0.9),
                                  ],
                                  stops: const [0.0, 0.45, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),

                          // NOTE: TV Show Info
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tvShow.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: heading5TextStyle.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: primaryColor,
                                      size: 18.sp,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tvShow.formattedRating,
                                      style: heading6TextStyle.copyWith(
                                        color: whiteColor,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    if (tvShow.releaseYear.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '•',
                                        style: paragraphSmallTextStyle.copyWith(
                                          color: Colors.white54,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        tvShow.releaseYear,
                                        style: paragraphSmallTextStyle.copyWith(
                                          color: Colors.white70,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildLoadingState() {
    return FlutterCarousel(
      options: FlutterCarouselOptions(
        height: 440,
        showIndicator: true,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        enlargeFactor: 80 / 440,
        viewportFraction: 0.85,
        enableInfiniteScroll: true,
        autoPlay: false,
        slideIndicator: CircularSlideIndicator(
          slideIndicatorOptions: SlideIndicatorOptions(
            indicatorRadius: 4,
            itemSpacing: 12,
            currentIndicatorColor: primaryColor,
            indicatorBackgroundColor: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),
      items: List.generate(3, (index) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildErrorState(TvshowController controller) {
    return Container(
      width: double.infinity,
      height: 360,
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load TV shows',
              style: paragraphSmallTextStyle.copyWith(
                color: whiteColor,
                fontSize: 14.sp,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () => controller.fetchOnTheAirTvShows(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retry',
                style: heading6TextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
