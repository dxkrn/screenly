import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/modules/discover/controllers/discover_controller.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';

void main() {
  setUp(() {
    Get.deleteAll(force: true);
    Get.reset();
  });

  group('DiscoverController Pagination', () {
    test('fetchSearchMulti sets pagination metadata from response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/search/multi')) {
          return http.Response(
            json.encode({
              'page': 1,
              'total_pages': 3,
              'total_results': 60,
              'results': [
                {
                  'id': 101,
                  'title': 'Dune Part 1',
                  'media_type': 'movie',
                  'vote_average': 8.2,
                },
              ],
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = TmdbService(client: mockClient);
      final controller = DiscoverController(tmdbService: service);
      controller.onInit();

      await controller.fetchSearchMulti('dune');

      expect(controller.currentPage.value, 1);
      expect(controller.totalPages.value, 3);
      expect(controller.hasMoreData.value, isTrue);
      expect(controller.searchResults.length, 1);
      expect(controller.searchResults.first.title, 'Dune Part 1');

      controller.onClose();
    });

    test('loadMore appends new results and updates page count', () async {
      int requestPage = 1;
      final mockClient = MockClient((request) async {
        requestPage = int.parse(request.url.queryParameters['page'] ?? '1');
        return http.Response(
          json.encode({
            'page': requestPage,
            'total_pages': 2,
            'total_results': 2,
            'results': [
              {
                'id': requestPage == 1 ? 101 : 202,
                'title': requestPage == 1 ? 'Batman 1' : 'Batman 2',
                'media_type': 'movie',
                'vote_average': 7.5,
              },
            ],
          }),
          200,
        );
      });

      final service = TmdbService(client: mockClient);
      final controller = DiscoverController(tmdbService: service);
      controller.onInit();

      await controller.fetchSearchMulti('batman');
      expect(controller.currentPage.value, 1);
      expect(controller.hasMoreData.value, isTrue);
      expect(controller.searchResults.length, 1);

      // Load page 2
      await controller.loadMore();

      expect(controller.currentPage.value, 2);
      expect(controller.hasMoreData.value, isFalse);
      expect(controller.searchResults.length, 2);
      expect(controller.searchResults[1].title, 'Batman 2');

      // Subsequent loadMore should not trigger when hasMoreData is false
      await controller.loadMore();
      expect(controller.currentPage.value, 2);
      expect(controller.searchResults.length, 2);

      controller.onClose();
    });

    test('clearSearch resets all pagination states', () {
      final controller = DiscoverController();
      controller.onInit();

      controller.currentPage.value = 5;
      controller.totalPages.value = 10;
      controller.hasMoreData.value = true;
      controller.isLoadingMore.value = true;
      controller.searchResults.add(SearchResultModel(id: 1, title: 'Item'));

      controller.clearSearch();

      expect(controller.currentPage.value, 1);
      expect(controller.totalPages.value, 1);
      expect(controller.hasMoreData.value, isFalse);
      expect(controller.isLoadingMore.value, isFalse);
      expect(controller.searchResults, isEmpty);

      controller.onClose();
    });
  });

  group('DiscoverView Infinite Scroll UI', () {
    testWidgets('renders bottom progress indicator when isLoadingMore is true',
        (tester) async {
      final controller = Get.put(DiscoverController());
      controller.isLoading.value = false;
      controller.hasSearched.value = true;
      controller.searchResults.assignAll([
        SearchResultModel(
          id: 1,
          title: 'Movie 1',
          mediaType: 'movie',
          voteAverage: 7.0,
        ),
        SearchResultModel(
          id: 2,
          title: 'Movie 2',
          mediaType: 'movie',
          voteAverage: 8.0,
        ),
      ]);
      controller.isLoadingMore.value = true;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: DiscoverView(),
          ),
        ),
      );
      await tester.pump();

      // Scroll to bottom to reveal bottom sliver
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Movie 1'), findsOneWidget);
      expect(find.text('Movie 2'), findsOneWidget);
    });
  });
}
