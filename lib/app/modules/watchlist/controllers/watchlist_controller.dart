import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';
import 'package:screenly/app/modules/home/controllers/home_controller.dart';
import 'package:screenly/utils/preferences_utils.dart';

class WatchlistController extends GetxController {
  final TmdbService _movieService = TmdbService();
  final TmdbTvShowService _tvShowService = TmdbTvShowService();

  final isLoading = true.obs;
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
    loadBookmarks();
    if (Get.isRegistered<HomeController>()) {
      ever(Get.find<HomeController>().selectedIndex, (index) {
        if (index == 2) {
          loadBookmarks();
        }
      });
    }
  }

  Future<void> loadBookmarks() async {
    try {
      isLoading.value = true;
      final rawItems = await PreferencesUtils.getBookmarkItems();
      final List<SearchResultModel> loaded = [];

      for (final raw in rawItems) {
        final id = raw['id'] as int? ?? 0;
        if (id <= 0) continue;

        if (raw['title'] != null || raw['name'] != null) {
          loaded.add(SearchResultModel.fromJson(raw));
        } else {
          try {
            final movie = await _movieService.getMovieDetail(id);
            final itemMap = {
              'id': movie.id,
              'title': movie.title,
              'poster_path': movie.posterPath,
              'backdrop_path': movie.backdropPath,
              'vote_average': movie.voteAverage,
              'vote_count': movie.voteCount,
              'media_type': 'movie',
              'release_date': movie.releaseDate,
            };
            await PreferencesUtils.addBookmark(id, itemMap);
            loaded.add(SearchResultModel.fromJson(itemMap));
          } catch (_) {
            try {
              final tv = await _tvShowService.getTvShowDetail(id);
              final itemMap = {
                'id': tv.id,
                'title': tv.title,
                'poster_path': tv.posterPath,
                'backdrop_path': tv.backdropPath,
                'vote_average': tv.voteAverage,
                'vote_count': tv.voteCount,
                'media_type': 'tv',
                'release_date': tv.releaseDate,
              };
              await PreferencesUtils.addBookmark(id, itemMap);
              loaded.add(SearchResultModel.fromJson(itemMap));
            } catch (_) {
              loaded.add(SearchResultModel(id: id, title: 'Item #$id'));
            }
          }
        }
      }

      watchlistItems.assignAll(loaded);
    } catch (_) {
      // Keep existing list on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBookmark(int id) async {
    await PreferencesUtils.removeBookmark(id);
    watchlistItems.removeWhere((item) => item.id == id);
  }
}
