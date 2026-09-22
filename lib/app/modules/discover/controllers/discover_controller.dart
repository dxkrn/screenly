import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';

class DiscoverController extends GetxController {
  final TmdbService _tmdbService;

  DiscoverController({TmdbService? tmdbService})
      : _tmdbService = tmdbService ?? TmdbService();

  late final TextEditingController searchInputController;
  late final ScrollController scrollController;

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

      final response = await _tmdbService.searchMulti(
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
    if (lastSearchedQuery.isEmpty) return;

    try {
      isLoadingMore.value = true;
      final nextPage = currentPage.value + 1;

      final response = await _tmdbService.searchMulti(
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
      // Don't overwrite existing results on page pagination failure
    } finally {
      isLoadingMore.value = false;
    }
  }

  void retry() {
    if (lastSearchedQuery.isNotEmpty) {
      fetchSearchMulti(lastSearchedQuery.value);
    }
  }
}
