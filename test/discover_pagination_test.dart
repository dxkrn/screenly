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
import 'package:screenly/app/modules/movie/controllers/movie_controller.dart';
import 'package:screenly/app/modules/movie/views/sections/upcoming_section.dart';
import 'package:screenly/app/routes/app_pages.dart';

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

    test('category mode loads page 1 and paginates with loadMore', () async {
      int requestedPage = 1;
      final mockClient = MockClient((request) async {
        requestedPage = int.parse(request.url.queryParameters['page'] ?? '1');
        if (request.url.path.contains('/movie/upcoming')) {
          return http.Response(
            json.encode({
              'page': requestedPage,
              'total_pages': 3,
              'results': [
                {
                  'id': requestedPage == 1 ? 1001 : 1002,
                  'title': 'Upcoming Movie $requestedPage',
                  'vote_average': 8.0,
                  'release_date': '2026-10-01',
                }
              ],
            }),
            200,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = TmdbService(client: mockClient);
      final controller = DiscoverController(movieService: service);
      controller.onInit();

      await controller.loadCategory(
        category: 'movie_upcoming',
        title: 'Upcoming Movies',
        subtitle: 'Explore upcoming releases',
      );

      expect(controller.isCategoryMode.value, isTrue);
      expect(controller.titleText.value, 'Upcoming Movies');
      expect(controller.subtitleText.value, 'Explore upcoming releases');
      expect(controller.currentPage.value, 1);
      expect(controller.totalPages.value, 3);
      expect(controller.hasMoreData.value, isTrue);
      expect(controller.searchResults.length, 1);
      expect(controller.searchResults.first.title, 'Upcoming Movie 1');

      // Paginate to page 2
      await controller.loadMore();

      expect(controller.currentPage.value, 2);
      expect(controller.searchResults.length, 2);
      expect(controller.searchResults[1].title, 'Upcoming Movie 2');

      controller.onClose();
    });
  });

  group('DiscoverView Modes and UI', () {
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

    testWidgets(
        'renders default search mode with search bar and no back button',
        (tester) async {
      final controller = Get.put(DiscoverController());
      controller.isLoading.value = false;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: DiscoverView(),
        ),
      );
      await tester.pump();
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Find and explore your favorite movies and TV shows'),
          findsOneWidget);
      // Search bar should be present
      expect(find.byType(TextField), findsOneWidget);
      // Back button should NOT be present
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
    });

    testWidgets(
        'renders category mode with custom title, back button, and hides search bar',
        (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: DiscoverView(
            categoryType: 'movie_upcoming',
            title: 'Upcoming Movies',
            subtitle: 'Explore upcoming theatrical releases',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Upcoming Movies'), findsOneWidget);
      expect(find.text('Explore upcoming theatrical releases'), findsOneWidget);
      // Search bar must NOT be visible in category mode
      expect(find.byType(TextField), findsNothing);
      // Back button must be present
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets(
        'UpcomingSection See All button triggers navigation with category arguments',
        (tester) async {
      // Register MovieController with mock service if needed
      final movieController = Get.put(MovieController());
      movieController.isLoadingUpcoming.value = false;

      await tester.pumpWidget(
        GetMaterialApp(
          getPages: AppPages.routes,
          home: const Scaffold(
            body: UpcomingSection(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Upcoming Movies'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);

      await tester.tap(find.text('See All'));
      await tester.pumpAndSettle();

      // Should now be on Discover screen in category mode
      expect(Get.currentRoute, Routes.DISCOVER);
      final args = Get.arguments as Map;
      expect(args['categoryType'], 'movie_upcoming');
      expect(args['title'], 'Upcoming Movies');
      // Search bar must be hidden
      expect(find.byType(TextField), findsNothing);
      // Back button must be visible
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });
}
