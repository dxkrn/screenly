import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';

class DiscoverController extends GetxController {
  final TmdbService _movieService;
  final TmdbTvShowService _tvShowService;

  DiscoverController({
    TmdbService? movieService,
    TmdbTvShowService? tvShowService,
    TmdbService? tmdbService,
  })  : _movieService = movieService ?? tmdbService ?? TmdbService(),
        _tvShowService = tvShowService ?? TmdbTvShowService();

  late final TextEditingController searchInputController;
  late final ScrollController scrollController;

  // Category navigation mode states
  final isCategoryMode = false.obs;
  final categoryType = ''.obs;
  final titleText = 'Discover'.obs;
  final subtitleText = 'Find and explore your favorite movies and TV shows'.obs;

  // Search and pagination states
  final searchInputText = ''.obs;
  final lastSearchedQuery = ''.obs;
  final hasSearched = false.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMoreData = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final errorMessage = ''.obs;
  final searchResults = <SearchResultModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchInputController = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchInputController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    // Trigger loading next page when user scrolls within 250px of the bottom
    if (currentScroll >= maxScroll - 250) {
      loadMore();
    }
  }

  /// Initialize and load a category collection (e.g. from UpcomingSection)
  Future<void> loadCategory({
    required String category,
    required String title,
    String? subtitle,
  }) async {
    isCategoryMode.value = true;
    categoryType.value = category;
    titleText.value = title;
    subtitleText.value = subtitle ?? 'Explore $title';
    hasSearched.value = true;
    currentPage.value = 1;
    searchResults.clear();
    errorMessage.value = '';

    await fetchCategoryData(page: 1);
  }

  /// Fetch items for the active category with pagination
  Future<void> fetchCategoryData({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = '';

      List<SearchResultModel> items = [];
      int responseTotalPages = 1;

      switch (categoryType.value) {
        case 'movie_upcoming':
          final res = await _movieService.getUpcomingMovies(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (m) => SearchResultModel(
                  id: m.id,
                  title: m.title,
                  posterPath: m.posterPath,
                  backdropPath: m.backdropPath,
                  voteAverage: m.voteAverage,
                  voteCount: m.voteCount,
                  releaseDate: m.releaseDate,
                  mediaType: 'movie',
                ),
              )
              .toList();
          break;

        case 'movie_now_playing':
          final res = await _movieService.getNowPlayingMovies(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (m) => SearchResultModel(
                  id: m.id,
                  title: m.title,
                  posterPath: m.posterPath,
                  backdropPath: m.backdropPath,
                  voteAverage: m.voteAverage,
                  voteCount: m.voteCount,
                  releaseDate: m.releaseDate,
                  mediaType: 'movie',
                ),
              )
              .toList();
          break;

        case 'movie_popular':
          final res = await _movieService.getPopularMovies(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (m) => SearchResultModel(
                  id: m.id,
                  title: m.title,
                  posterPath: m.posterPath,
                  backdropPath: m.backdropPath,
                  voteAverage: m.voteAverage,
                  voteCount: m.voteCount,
                  releaseDate: m.releaseDate,
                  mediaType: 'movie',
                ),
              )
              .toList();
          break;

        case 'movie_top_rated':
          final res = await _movieService.getTopRatedMovies(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (m) => SearchResultModel(
                  id: m.id,
                  title: m.title,
                  posterPath: m.posterPath,
                  backdropPath: m.backdropPath,
                  voteAverage: m.voteAverage,
                  voteCount: m.voteCount,
                  releaseDate: m.releaseDate,
                  mediaType: 'movie',
                ),
              )
              .toList();
          break;

        case 'tv_popular':
          final res = await _tvShowService.getPopularTvShows(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (t) => SearchResultModel(
                  id: t.id,
                  title: t.name,
                  posterPath: t.posterPath,
                  backdropPath: t.backdropPath,
                  voteAverage: t.voteAverage,
                  voteCount: t.voteCount,
                  releaseDate: t.firstAirDate,
                  mediaType: 'tv',
                ),
              )
              .toList();
          break;

        case 'tv_top_rated':
          final res = await _tvShowService.getTopRatedTvShows(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (t) => SearchResultModel(
                  id: t.id,
                  title: t.name,
                  posterPath: t.posterPath,
                  backdropPath: t.backdropPath,
                  voteAverage: t.voteAverage,
                  voteCount: t.voteCount,
                  releaseDate: t.firstAirDate,
                  mediaType: 'tv',
                ),
              )
              .toList();
          break;

        case 'tv_on_the_air':
          final res = await _tvShowService.getOnTheAirTvShows(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (t) => SearchResultModel(
                  id: t.id,
                  title: t.name,
                  posterPath: t.posterPath,
                  backdropPath: t.backdropPath,
                  voteAverage: t.voteAverage,
                  voteCount: t.voteCount,
                  releaseDate: t.firstAirDate,
                  mediaType: 'tv',
                ),
              )
              .toList();
          break;

        case 'tv_airing_today':
          final res = await _tvShowService.getAiringTodayTvShows(page: page);
          responseTotalPages = res.totalPages ?? 1;
          items = res.results
              .map(
                (t) => SearchResultModel(
                  id: t.id,
                  title: t.name,
                  posterPath: t.posterPath,
                  backdropPath: t.backdropPath,
                  voteAverage: t.voteAverage,
                  voteCount: t.voteCount,
                  releaseDate: t.firstAirDate,
                  mediaType: 'tv',
                ),
              )
              .toList();
          break;

        default:
          throw Exception('Unsupported category: ${categoryType.value}');
      }

      if (page == 1) {
        searchResults.assignAll(items);
      } else {
        searchResults.addAll(items);
      }

      currentPage.value = page;
      totalPages.value = responseTotalPages;
      hasMoreData.value = currentPage.value < totalPages.value;
    } catch (e) {
      if (page == 1) {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchInputText.value = value;
  }

  void clearSearch() {
    searchInputController.clear();
    searchInputText.value = '';
    lastSearchedQuery.value = '';
    hasSearched.value = false;
    searchResults.clear();
    errorMessage.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
    hasMoreData.value = false;
    isLoadingMore.value = false;
  }

  Future<void> fetchSearchMulti(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      lastSearchedQuery.value = trimmedQuery;
      hasSearched.value = true;
      currentPage.value = 1;

      final response = await _movieService.searchMulti(
        query: trimmedQuery,
        page: 1,
      );

      final filteredResults =
          response.results.where((item) => item.isMovieOrTv).toList();
      searchResults.assignAll(filteredResults);

      totalPages.value = response.totalPages ?? 1;
      hasMoreData.value = currentPage.value < totalPages.value;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMoreData.value) return;

    if (isCategoryMode.value) {
      await fetchCategoryData(page: currentPage.value + 1);
    } else {
      if (lastSearchedQuery.isEmpty) return;

      try {
        isLoadingMore.value = true;
        final nextPage = currentPage.value + 1;

        final response = await _movieService.searchMulti(
          query: lastSearchedQuery.value,
          page: nextPage,
        );

        final filteredResults =
            response.results.where((item) => item.isMovieOrTv).toList();
        searchResults.addAll(filteredResults);

        currentPage.value = nextPage;
        totalPages.value = response.totalPages ?? currentPage.value;
        hasMoreData.value = currentPage.value < totalPages.value;
      } catch (_) {
        // Keep current items on pagination network error
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  void retry() {
    if (isCategoryMode.value) {
      fetchCategoryData(page: 1);
    } else if (lastSearchedQuery.isNotEmpty) {
      fetchSearchMulti(lastSearchedQuery.value);
    }
  }
}
