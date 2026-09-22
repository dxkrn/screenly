import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';

class DiscoverController extends GetxController {
  final TmdbService _tmdbService = TmdbService();

  late final TextEditingController searchInputController;

  final searchInputText = ''.obs;
  final lastSearchedQuery = ''.obs;
  final hasSearched = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchResults = <SearchResultModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchInputController = TextEditingController();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
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

      final response = await _tmdbService.searchMulti(query: trimmedQuery);
      final filteredResults =
          response.results.where((item) => item.isMovieOrTv).toList();
      searchResults.assignAll(filteredResults);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    if (lastSearchedQuery.isNotEmpty) {
      fetchSearchMulti(lastSearchedQuery.value);
    }
  }
}
