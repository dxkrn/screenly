import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/media_detail_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';
import 'package:screenly/utils/preferences_utils.dart';

class DetailsController extends GetxController {
  final TmdbService _movieService;
  final TmdbTvShowService _tvShowService;
  final bool autoFetch;

  DetailsController({
    TmdbService? movieService,
    TmdbTvShowService? tvShowService,
    this.autoFetch = true,
  })  : _movieService = movieService ?? TmdbService(),
        _tvShowService = tvShowService ?? TmdbTvShowService();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final detail = Rxn<MediaDetailModel>();

  final mediaId = 0.obs;
  final mediaType = 'movie'.obs; // 'movie' or 'tv'
  final isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    checkBookmarkStatus();
    if (autoFetch) {
      fetchDetails();
    }
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['id'] != null) {
        mediaId.value = (args['id'] as num).toInt();
      }
      if (args['type'] != null) {
        mediaType.value = args['type'].toString().toLowerCase();
      }
    } else if (args is int) {
      mediaId.value = args;
    }
  }

  Future<void> checkBookmarkStatus() async {
    final id = mediaId.value > 0 ? mediaId.value : (detail.value?.id ?? 0);
    if (id <= 0) return;
    try {
      final bookmarked = await PreferencesUtils.isBookmarked(id);
      isBookmarked.value = bookmarked;
    } catch (_) {}
  }

  Future<void> toggleBookmark() async {
    final id = mediaId.value > 0 ? mediaId.value : (detail.value?.id ?? 0);
    if (id <= 0) return;

    try {
      final currentDetail = detail.value;
      Map<String, dynamic>? itemData;
      if (currentDetail != null) {
        itemData = {
          'id': currentDetail.id,
          'title': currentDetail.title,
          'poster_path': currentDetail.posterPath,
          'backdrop_path': currentDetail.backdropPath,
          'vote_average': currentDetail.voteAverage,
          'media_type': mediaType.value,
          'release_date': currentDetail.releaseDate,
        };
      }

      final nowBookmarked = await PreferencesUtils.toggleBookmark(id, itemData);
      isBookmarked.value = nowBookmarked;

      // Get.snackbar(
      //   nowBookmarked ? 'Added to Watchlist' : 'Removed from Watchlist',
      //   currentDetail?.title ??
      //       (nowBookmarked ? 'Saved to bookmarks' : 'Removed from bookmarks'),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: const Color(0xFF1E1E1E),
      //   colorText: Colors.white,
      //   margin: const EdgeInsets.all(16),
      //   borderRadius: 12,
      //   duration: const Duration(seconds: 2),
      //   icon: Icon(
      //     nowBookmarked
      //         ? Icons.bookmark_rounded
      //         : Icons.bookmark_outline_rounded,
      //     color: primaryColor,
      //   ),
      // );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update bookmark: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> fetchDetails() async {
    if (mediaId.value <= 0) {
      errorMessage.value = 'Invalid media ID';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (mediaType.value == 'tv') {
        final result = await _tvShowService.getTvShowDetail(mediaId.value);
        detail.value = result;
      } else {
        final result = await _movieService.getMovieDetail(mediaId.value);
        detail.value = result;
      }

      if (mediaId.value == 0 && detail.value != null) {
        mediaId.value = detail.value!.id;
        checkBookmarkStatus();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchDetails();
  }
}
