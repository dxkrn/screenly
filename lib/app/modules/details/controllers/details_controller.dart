import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/components/login_required_dialog.dart';
import 'package:screenly/app/data/models/media_detail_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';
import 'package:screenly/app/data/services/tmdb_watchlist_service.dart';
import 'package:screenly/utils/preferences_utils.dart';

class DetailsController extends GetxController {
  final TmdbService _movieService;
  final TmdbTvShowService _tvShowService;
  final TmdbWatchlistService _watchlistService;
  final bool autoFetch;

  DetailsController({
    TmdbService? movieService,
    TmdbTvShowService? tvShowService,
    TmdbWatchlistService? watchlistService,
    this.autoFetch = true,
  })  : _movieService = movieService ?? TmdbService(),
        _tvShowService = tvShowService ?? TmdbTvShowService(),
        _watchlistService = watchlistService ?? TmdbWatchlistService();

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

    final isLoggedIn = await PreferencesUtils.isTmdbLoggedIn();
    if (!isLoggedIn) {
      isBookmarked.value = false;
      return;
    }

    final sessionId = await PreferencesUtils.getTmdbSessionId();
    if (sessionId != null) {
      final inWatchlist = await _watchlistService.isItemInWatchlist(
        mediaId: id,
        mediaType: mediaType.value,
        sessionId: sessionId,
      );
      isBookmarked.value = inWatchlist;
    }
  }

  Future<void> toggleBookmark() async {
    final id = mediaId.value > 0 ? mediaId.value : (detail.value?.id ?? 0);
    if (id <= 0) return;

    final isLoggedIn = await PreferencesUtils.isTmdbLoggedIn();
    if (!isLoggedIn) {
      LoginRequiredDialog.show();
      return;
    }

    final accountId = await PreferencesUtils.getTmdbAccountId();
    final sessionId = await PreferencesUtils.getTmdbSessionId();
    if (accountId == null || sessionId == null) return;

    try {
      final nextStatus = !isBookmarked.value;
      final type = mediaType.value.isNotEmpty ? mediaType.value : 'movie';
      await _watchlistService.updateWatchlist(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: type,
        mediaId: id,
        watchlist: nextStatus,
      );

      isBookmarked.value = nextStatus;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update watchlist: $e',
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
