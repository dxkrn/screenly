import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/media_detail_model.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingView();
        }

        if (controller.errorMessage.isNotEmpty ||
            controller.detail.value == null) {
          return _buildErrorView();
        }

        final detail = controller.detail.value!;
        return _buildContentView(context, detail);
      }),
    );
  }

  Widget _buildLoadingView() {
    return Stack(
      children: [
        Positioned(
          top: 48,
          left: 16,
          child: _buildBackButton(),
        ),
        Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Stack(
      children: [
        Positioned(
          top: 48,
          left: 16,
          child: _buildBackButton(),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white38,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load details',
                  style: heading5TextStyle.copyWith(color: whiteColor),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white60,
                    fontSize: 13.sp,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => controller.retry(),
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
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.back(),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context, MediaDetailModel detail) {
    return CustomScrollView(
      slivers: [
        // NOTE: Sliver App Bar with Backdrop
        SliverAppBar(
          expandedHeight: 280.h,
          pinned: true,
          elevation: 0,
          backgroundColor: const Color(0xFF141414),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBackButton(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (detail.fullBackdropUrl.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: detail.fullBackdropUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1E1E1E),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1E1E1E),
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  )
                else
                  Container(
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(
                      Icons.movie_rounded,
                      color: Colors.white38,
                      size: 48,
                    ),
                  ),
                // Gradient overlay
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                        const Color(0xFF141414).withValues(alpha: 0.8),
                        const Color(0xFF141414),
                      ],
                      stops: const [0.0, 0.3, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // NOTE: Content Body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(detail),
                const SizedBox(height: 16),
                _buildRatingBar(detail),
                const SizedBox(height: 16),
                if (detail.genres.isNotEmpty) ...[
                  _buildGenresWrap(detail),
                  const SizedBox(height: 20),
                ],
                if (detail.overview != null && detail.overview!.isNotEmpty) ...[
                  _buildStorylineSection(detail),
                  const SizedBox(height: 24),
                ],
                if (detail.isTv && detail.seasons.isNotEmpty) ...[
                  _buildSeasonsSection(detail),
                  const SizedBox(height: 24),
                ],
                if (detail.isTv && detail.createdBy.isNotEmpty) ...[
                  _buildCreatorsSection(detail),
                  const SizedBox(height: 24),
                ],
                if (detail.isTv && detail.networks.isNotEmpty) ...[
                  _buildNetworksSection(detail),
                  const SizedBox(height: 24),
                ],
                _buildSpecificationsSection(detail),
                const SizedBox(height: 24),
                if (detail.productionCompanies.isNotEmpty) ...[
                  _buildProductionCompaniesSection(detail),
                  const SizedBox(height: 24),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // NOTE: Poster, Title, Tagline, and Type Badge
  Widget _buildHeroSection(MediaDetailModel detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster image
        Container(
          width: 105.w,
          height: 155.h,
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: detail.fullPosterUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: detail.fullPosterUrl,
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
                      Icons.movie_creation_outlined,
                      color: Colors.white38,
                    ),
                  ),
                )
              : Container(
                  color: const Color(0xFF1E1E1E),
                  child: const Icon(
                    Icons.movie_creation_outlined,
                    color: Colors.white38,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        // Title & metadata
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge (MOVIE or TV SHOW)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  detail.isMovie ? 'MOVIE' : 'TV SHOW',
                  style: paragraphSmallTextStyle.copyWith(
                    color: blackColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                detail.title,
                style: heading4TextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  height: 1.2,
                ),
              ),
              if (detail.tagline != null && detail.tagline!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '"${detail.tagline}"',
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                    fontSize: 12.sp,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (detail.releaseYear.isNotEmpty)
                    Text(
                      detail.releaseYear,
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (detail.isMovie && detail.formattedRuntime.isNotEmpty) ...[
                    _buildDotSeparator(),
                    Text(
                      detail.formattedRuntime,
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                  if (detail.isTv &&
                      detail.seasonsAndEpisodesText.isNotEmpty) ...[
                    _buildDotSeparator(),
                    Text(
                      detail.seasonsAndEpisodesText,
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                  if (detail.status != null && detail.status!.isNotEmpty) ...[
                    _buildDotSeparator(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        detail.status!,
                        style: paragraphSmallTextStyle.copyWith(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // NOTE: Rating, votes, and popularity
  Widget _buildRatingBar(MediaDetailModel detail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Rating
          Row(
            children: [
              Icon(Icons.star_rounded, color: primaryColor, size: 22.sp),
              const SizedBox(width: 6),
              Text(
                detail.formattedRating,
                style: heading5TextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              if (detail.voteCount != null && detail.voteCount! > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '(${detail.voteCount})',
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.white54,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ],
          ),
          // Divider
          Container(
            width: 1,
            height: 24,
            color: Colors.white12,
          ),
          // Popularity
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF6D00),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                detail.popularity != null
                    ? detail.popularity!.toStringAsFixed(0)
                    : '-',
                style: heading5TextStyle.copyWith(
                  color: whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Popularity',
                style: paragraphSmallTextStyle.copyWith(
                  color: Colors.white54,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          if (detail.adult == true) ...[
            Container(
              width: 1,
              height: 24,
              color: Colors.white12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Text(
                '18+',
                style: paragraphSmallTextStyle.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // NOTE: Genres Chips
  Widget _buildGenresWrap(MediaDetailModel detail) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: detail.genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            genre.name,
            style: paragraphSmallTextStyle.copyWith(
              color: whiteColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  // NOTE: Storyline Section
  Widget _buildStorylineSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storyline',
          style: heading5TextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail.overview!,
          style: paragraphRegulerTextStyle.copyWith(
            color: Colors.white70,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // NOTE: TV Show Seasons
  Widget _buildSeasonsSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Seasons (${detail.seasons.length})',
              style: heading5TextStyle.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: detail.seasons.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final season = detail.seasons[index];
              return Container(
                width: 120.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: season.fullPosterUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: season.fullPosterUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFF242424),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFF242424),
                                child: const Icon(
                                  Icons.tv_rounded,
                                  color: Colors.white24,
                                ),
                              ),
                            )
                          : Container(
                              color: const Color(0xFF242424),
                              child: const Center(
                                child: Icon(
                                  Icons.tv_rounded,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            season.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: heading6TextStyle.copyWith(
                              color: whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${season.episodeCount} Episodes',
                            style: paragraphSmallTextStyle.copyWith(
                              color: Colors.white54,
                              fontSize: 11.sp,
                            ),
                          ),
                          if (season.airYear.isNotEmpty)
                            Text(
                              season.airYear,
                              style: paragraphSmallTextStyle.copyWith(
                                color: primaryColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // NOTE: TV Show Creators
  Widget _buildCreatorsSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Created By',
          style: heading5TextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: detail.createdBy.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final creator = detail.createdBy[index];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF242424),
                    backgroundImage: creator.fullProfileUrl.isNotEmpty
                        ? CachedNetworkImageProvider(creator.fullProfileUrl)
                        : null,
                    child: creator.fullProfileUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white38)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    creator.name,
                    style: paragraphSmallTextStyle.copyWith(
                      color: whiteColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // NOTE: TV Show Networks
  Widget _buildNetworksSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Networks',
          style: heading5TextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: detail.networks.map((network) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: network.fullLogoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: network.fullLogoUrl,
                      height: 20,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Text(
                        network.name,
                        style: paragraphSmallTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Text(
                      network.name,
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // NOTE: Specifications / Information Grid
  Widget _buildSpecificationsSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: heading5TextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              if (detail.originalTitle != null &&
                  detail.originalTitle!.isNotEmpty)
                _buildInfoRow('Title', detail.originalTitle!),
              if (detail.originalLanguage != null &&
                  detail.originalLanguage!.isNotEmpty)
                _buildInfoRow(
                    'Language', detail.originalLanguage!.toUpperCase()),
              if (detail.status != null && detail.status!.isNotEmpty)
                _buildInfoRow('Status', detail.status!),
              if (detail.releaseDate != null && detail.releaseDate!.isNotEmpty)
                _buildInfoRow(
                  detail.isMovie ? 'Release Date' : 'First Air Date',
                  detail.releaseDate!,
                ),
              if (detail.isTv &&
                  detail.lastAirDate != null &&
                  detail.lastAirDate!.isNotEmpty)
                _buildInfoRow('Last Air Date', detail.lastAirDate!),
              if (detail.isMovie &&
                  detail.runtime != null &&
                  detail.runtime! > 0)
                _buildInfoRow('Runtime', '${detail.runtime} minutes'),
              if (detail.isMovie && detail.budget != null && detail.budget! > 0)
                _buildInfoRow('Budget', detail.formattedBudget),
              if (detail.isMovie &&
                  detail.revenue != null &&
                  detail.revenue! > 0)
                _buildInfoRow('Revenue', detail.formattedRevenue),
              if (detail.isTv && detail.type != null && detail.type!.isNotEmpty)
                _buildInfoRow('Show Type', detail.type!),
              // if (detail.homepage != null && detail.homepage!.isNotEmpty)
              //   _buildInfoRow('Website', detail.homepage!, isUrl: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isUrl = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(
              label,
              style: paragraphSmallTextStyle.copyWith(
                color: Colors.white54,
                fontSize: 13.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: paragraphSmallTextStyle.copyWith(
                color: isUrl ? primaryColor : whiteColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NOTE: Production Companies
  Widget _buildProductionCompaniesSection(MediaDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Production',
          style: heading5TextStyle.copyWith(
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.productionCompanies.map((company) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                company.name,
                style: paragraphSmallTextStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDotSeparator() {
    return Text(
      '•',
      style: paragraphSmallTextStyle.copyWith(
        color: Colors.white38,
        fontSize: 12.sp,
      ),
    );
  }
}
