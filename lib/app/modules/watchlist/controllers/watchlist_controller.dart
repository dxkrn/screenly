import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';
import 'package:screenly/app/data/services/tmdb_watchlist_service.dart';
import 'package:screenly/app/modules/home/controllers/home_controller.dart';
import 'package:screenly/app/modules/profile/controllers/profile_controller.dart';
import 'package:screenly/utils/preferences_utils.dart';

class WatchlistController extends GetxController {
  final TmdbWatchlistService _watchlistService;
  final bool autoLoad;

  WatchlistController({
    TmdbService? movieService,
    TmdbTvShowService? tvShowService,
    TmdbWatchlistService? watchlistService,
    this.autoLoad = true,
  }) : _watchlistService = watchlistService ?? TmdbWatchlistService();

  final isLoading = true.obs;
  final isTmdbConnected = false.obs;
  final watchlistItems = <SearchResultModel>[].obs;
  final selectedFilter = 'all'.obs; // 'all', 'movie', 'tv'

  int get movieCount => watchlistItems.where((item) => item.isMovie).length;
  int get tvCount => watchlistItems.where((item) => item.isTv).length;

  List<SearchResultModel> get filteredItems {
    if (selectedFilter.value == 'movie') {
      return watchlistItems.where((item) => item.isMovie).toList();
    } else if (selectedFilter.value == 'tv') {
      return watchlistItems.where((item) => item.isTv).toList();
    }
    return watchlistItems;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  @override
  void onInit() {
    super.onInit();
    if (autoLoad) {
      loadBookmarks();
    }
    if (Get.isRegistered<HomeController>()) {
      ever(Get.find<HomeController>().selectedIndex, (index) {
        if (index == 2) {
          loadBookmarks();
        }
      });
    }
    if (Get.isRegistered<ProfileController>()) {
      ever(Get.find<ProfileController>().isLoggedIn, (_) {
        loadBookmarks();
      });
    }
  }

  Future<void> loadBookmarks() async {
    try {
      isLoading.value = true;
      final loggedIn = await PreferencesUtils.isTmdbLoggedIn();
      isTmdbConnected.value = loggedIn;

      if (!loggedIn) {
        watchlistItems.clear();
        return;
      }

      final accountId = await PreferencesUtils.getTmdbAccountId();
      final sessionId = await PreferencesUtils.getTmdbSessionId();

      if (accountId == null || sessionId == null) {
        watchlistItems.clear();
        return;
      }

      final results = await Future.wait([
        _watchlistService.getWatchlistMovies(
          accountId: accountId,
          sessionId: sessionId,
          page: 1,
        ),
        _watchlistService.getWatchlistTvShows(
          accountId: accountId,
          sessionId: sessionId,
          page: 1,
        ),
      ]);

      final movieResponse = results[0];
      final tvResponse = results[1];

      final List<SearchResultModel> combined = [];
      combined.addAll(movieResponse.results);
      combined.addAll(tvResponse.results);

      watchlistItems.assignAll(combined);
    } catch (_) {
      // Keep existing list on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBookmark(int id, {String? mediaType}) async {
    final loggedIn = await PreferencesUtils.isTmdbLoggedIn();
    if (loggedIn) {
      final accountId = await PreferencesUtils.getTmdbAccountId();
      final sessionId = await PreferencesUtils.getTmdbSessionId();
      if (accountId != null && sessionId != null) {
        try {
          final target =
              watchlistItems.firstWhereOrNull((item) => item.id == id);
          final type = mediaType ?? (target?.isTv == true ? 'tv' : 'movie');
          await _watchlistService.updateWatchlist(
            accountId: accountId,
            sessionId: sessionId,
            mediaType: type,
            mediaId: id,
            watchlist: false,
          );
        } catch (_) {}
      }
    }

    watchlistItems.removeWhere((item) => item.id == id);
  }
}
