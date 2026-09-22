import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:screenly/app/data/models/media_detail_model.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/models/tvshow_airing_today_model.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/data/models/tvshow_popular_model.dart';
import 'package:screenly/app/data/models/tvshow_top_rated_model.dart';
import 'package:screenly/app/modules/details/controllers/details_controller.dart';
import 'package:screenly/app/modules/details/views/details_view.dart';
import 'package:screenly/app/modules/discover/controllers/discover_controller.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/movie/views/components/populer_people_card.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';
import 'package:screenly/app/modules/watchlist/controllers/watchlist_controller.dart';
import 'package:screenly/app/modules/watchlist/views/watchlist_view.dart';
import 'package:screenly/utils/preferences_utils.dart';

void main() {
  setUpAll(() {
    final tempDir = Directory.systemTemp.createTempSync('screenly_test_');
    Hive.init(tempDir.path);
  });

  setUp(() {
    Get.reset();
  });

  testWidgets('MovieCard renders title and no vote when voteAvg is null',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(
            title: 'Upcoming Movie',
          ),
        ),
      ),
    );

    expect(find.text('Upcoming Movie'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNothing);
  });

  testWidgets(
      'MovieCard renders title, star icon, voteAvg, and voteCount when provided',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MovieCard(
            title: 'The Godfather',
            voteAvg: 8.7,
            voteCount: 19899,
          ),
        ),
      ),
    );

    expect(find.text('The Godfather'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.text('8.7'), findsOneWidget);
    expect(find.text('(19.9k)'), findsOneWidget);
  });

  testWidgets(
      'DiscoverView renders MovieCard for movies and empty container for non-movies',
      (tester) async {
    final controller = Get.put(DiscoverController());
    controller.isLoading.value = false;
    controller.searchResults.assignAll([
      SearchResultModel(
        id: 1,
        mediaType: 'movie',
        title: 'Spider-Man Movie',
        voteAverage: 8.0,
      ),
      SearchResultModel(
        id: 2,
        mediaType: 'tv',
        title: 'Spider-Man Series',
      ),
    ]);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: DiscoverView(),
        ),
      ),
    );
    await tester.pump();

    // Movie item rendered via MovieCard
    expect(find.text('Spider-Man Movie'), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);

    // Non-movie item rendered with centered title
    expect(find.text('Spider-Man Series'), findsOneWidget);
  });

  test('SearchResultModel isMovieOrTv correctly identifies movie and tv', () {
    final movie = SearchResultModel(id: 1, mediaType: 'movie');
    final tv = SearchResultModel(id: 2, mediaType: 'tv');
    final person = SearchResultModel(id: 3, mediaType: 'person');
    final other = SearchResultModel(id: 4, mediaType: 'unknown');

    expect(movie.isMovieOrTv, isTrue);
    expect(tv.isMovieOrTv, isTrue);
    expect(person.isMovieOrTv, isFalse);
    expect(other.isMovieOrTv, isFalse);
  });

  testWidgets(
      'DiscoverView does not show No results while typing before enter/submit',
      (tester) async {
    Get.put(DiscoverController());
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: DiscoverView(),
        ),
      ),
    );
    await tester.pump();

    // Type text into search field
    await tester.enterText(find.byType(TextField), 'batman');
    await tester.pump();

    // Should NOT show No results found
    expect(find.textContaining('No results found'), findsNothing);
    // Should show initial prompt
    expect(find.text('Search movies & TV shows'), findsOneWidget);
  });

  testWidgets('PopularPeopleCard renders name correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PopularPeopleCard(
            name: 'Jenna Ortega',
          ),
        ),
      ),
    );

    expect(find.text('Jenna Ortega'), findsOneWidget);
  });

  test('TvShowOnTheAirModel parses json and computes getters correctly', () {
    final json = {
      'id': 202250,
      'name': 'Dirty Linen',
      'original_name': 'Dirty Linen',
      'first_air_date': '2023-01-23',
      'poster_path': '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
      'backdrop_path': '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
      'vote_average': 7.64,
      'vote_count': 14,
      'overview': 'To exact vengeance...',
      'popularity': 123.45,
    };

    final tvShow = TvShowOnTheAirModel.fromJson(json);

    expect(tvShow.id, 202250);
    expect(tvShow.name, 'Dirty Linen');
    expect(tvShow.title, 'Dirty Linen');
    expect(tvShow.releaseYear, '2023');
    expect(tvShow.formattedRating, '7.6');
    expect(tvShow.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/mAJ84W6I8I272Da87qplS2Dp9ST.jpg');
    expect(tvShow.fullBackdropUrl,
        'https://image.tmdb.org/t/p/w780/mAJ84W6I8I272Da87qplS2Dp9ST.jpg');
  });

  testWidgets('TvshowCard renders title and vote average when provided',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TvshowCard(
            title: 'Dirty Linen',
            voteAvg: 5.0,
            voteCount: 13,
          ),
        ),
      ),
    );

    expect(find.text('Dirty Linen'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('(13)'), findsOneWidget);
  });

  test('TvShowAiringTodayModel parses json and computes getters correctly', () {
    final json = {
      'id': 202250,
      'name': 'Dirty Linen',
      'original_name': 'Dirty Linen',
      'first_air_date': '2023-01-23',
      'poster_path': '/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg',
      'backdrop_path': '/mAJ84W6I8I272Da87qplS2Dp9ST.jpg',
      'vote_average': 5.0,
      'vote_count': 13,
      'overview': 'To exact vengeance...',
      'popularity': 2797.914,
    };

    final tvShow = TvShowAiringTodayModel.fromJson(json);

    expect(tvShow.id, 202250);
    expect(tvShow.name, 'Dirty Linen');
    expect(tvShow.title, 'Dirty Linen');
    expect(tvShow.releaseYear, '2023');
    expect(tvShow.formattedRating, '5.0');
    expect(tvShow.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg');
    expect(tvShow.fullBackdropUrl,
        'https://image.tmdb.org/t/p/w780/mAJ84W6I8I272Da87qplS2Dp9ST.jpg');
  });

  test('TvShowPopularModel parses json and computes getters correctly', () {
    final json = {
      'id': 203504,
      'name': 'Aashiqana',
      'original_name': 'आशिकाना',
      'first_air_date': '2022-06-06',
      'poster_path': '/a4Z6Uohb6Ln5vcPvMUzwyn3WBjP.jpg',
      'backdrop_path': '/wJmcuxa0C4AERmA9mejxm9qRYDj.jpg',
      'vote_average': 6.1,
      'vote_count': 10,
      'overview': 'A serial killer sparks the story...',
      'popularity': 2732.908,
    };

    final tvShow = TvShowPopularModel.fromJson(json);

    expect(tvShow.id, 203504);
    expect(tvShow.name, 'Aashiqana');
    expect(tvShow.title, 'Aashiqana');
    expect(tvShow.releaseYear, '2022');
    expect(tvShow.formattedRating, '6.1');
    expect(tvShow.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/a4Z6Uohb6Ln5vcPvMUzwyn3WBjP.jpg');
    expect(tvShow.fullBackdropUrl,
        'https://image.tmdb.org/t/p/w780/wJmcuxa0C4AERmA9mejxm9qRYDj.jpg');
  });

  test('TvShowTopRatedModel parses json and computes getters correctly', () {
    final json = {
      'id': 1396,
      'name': 'Breaking Bad',
      'original_name': 'Breaking Bad',
      'first_air_date': '2008-01-20',
      'poster_path': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
      'backdrop_path': '/bsNm9z2TJfe0WO3RedPGWQ8mG1X.jpg',
      'vote_average': 8.9,
      'vote_count': 11543,
      'overview': 'When Walter White, a New Mexico chemistry teacher...',
      'popularity': 292.904,
    };

    final tvShow = TvShowTopRatedModel.fromJson(json);

    expect(tvShow.id, 1396);
    expect(tvShow.name, 'Breaking Bad');
    expect(tvShow.title, 'Breaking Bad');
    expect(tvShow.releaseYear, '2008');
    expect(tvShow.formattedRating, '8.9');
    expect(tvShow.fullPosterUrl,
        'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg');
    expect(tvShow.fullBackdropUrl,
        'https://image.tmdb.org/t/p/w780/bsNm9z2TJfe0WO3RedPGWQ8mG1X.jpg');
  });

  test('MediaDetailModel.fromMovieJson parses fields and getters correctly',
      () {
    final json = {
      'id': 550,
      'title': 'Fight Club',
      'tagline': 'Mischief. Mayhem. Soap.',
      'overview': 'A ticking-time-bomb insomniac...',
      'poster_path': '/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg',
      'backdrop_path': '/c6OLXfKAk5BKeR6broC8pYiCquX.jpg',
      'release_date': '1999-10-15',
      'runtime': 139,
      'budget': 63000000,
      'revenue': 100853753,
      'vote_average': 8.437,
      'vote_count': 32897,
      'genres': [
        {'id': 18, 'name': 'Drama'},
        {'id': 53, 'name': 'Thriller'},
      ],
      'status': 'Released',
    };

    final detail = MediaDetailModel.fromMovieJson(json);

    expect(detail.id, 550);
    expect(detail.isMovie, isTrue);
    expect(detail.isTv, isFalse);
    expect(detail.title, 'Fight Club');
    expect(detail.tagline, 'Mischief. Mayhem. Soap.');
    expect(detail.releaseYear, '1999');
    expect(detail.formattedRuntime, '2h 19m');
    expect(detail.formattedRating, '8.4');
    expect(detail.formattedBudget, '\$63,000,000');
    expect(detail.formattedRevenue, '\$100,853,753');
    expect(detail.genres.length, 2);
    expect(detail.genres.first.name, 'Drama');
  });

  test('MediaDetailModel.fromTvJson parses TV fields and getters correctly',
      () {
    final json = {
      'id': 1399,
      'name': 'Game of Thrones',
      'tagline': 'Winter Is Coming',
      'first_air_date': '2011-04-17',
      'number_of_seasons': 8,
      'number_of_episodes': 73,
      'vote_average': 8.438,
      'vote_count': 21390,
      'genres': [
        {'id': 10765, 'name': 'Sci-Fi & Fantasy'},
        {'id': 18, 'name': 'Drama'},
      ],
      'created_by': [
        {
          'id': 9813,
          'name': 'David Benioff',
          'profile_path': '/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg',
        }
      ],
      'seasons': [
        {
          'id': 3624,
          'name': 'Season 1',
          'episode_count': 10,
          'season_number': 1,
          'air_date': '2011-04-17',
          'vote_average': 8.3,
        }
      ],
      'status': 'Ended',
    };

    final detail = MediaDetailModel.fromTvJson(json);

    expect(detail.id, 1399);
    expect(detail.isMovie, isFalse);
    expect(detail.isTv, isTrue);
    expect(detail.title, 'Game of Thrones');
    expect(detail.releaseYear, '2011');
    expect(detail.seasonsAndEpisodesText, '8 Seasons • 73 Episodes');
    expect(detail.formattedRating, '8.4');
    expect(detail.createdBy.length, 1);
    expect(detail.createdBy.first.name, 'David Benioff');
    expect(detail.seasons.length, 1);
    expect(detail.seasons.first.name, 'Season 1');
    expect(detail.seasons.first.airYear, '2011');
  });

  testWidgets('DetailsView renders media details when loaded', (tester) async {
    final controller = Get.put(DetailsController());
    controller.isLoading.value = false;
    controller.errorMessage.value = '';
    controller.detail.value = MediaDetailModel(
      id: 550,
      mediaType: 'movie',
      title: 'Fight Club',
      tagline: 'Mischief. Mayhem. Soap.',
      overview: 'A ticking-time-bomb insomniac...',
      releaseDate: '1999-10-15',
      runtime: 139,
      voteAverage: 8.4,
      voteCount: 32000,
      status: 'Released',
      genres: [GenreModel(id: 18, name: 'Drama')],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const GetMaterialApp(
          home: DetailsView(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Fight Club'), findsOneWidget);
    expect(find.text('"Mischief. Mayhem. Soap."'), findsOneWidget);
    expect(find.text('MOVIE'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('Storyline'), findsOneWidget);
    expect(find.text('A ticking-time-bomb insomniac...'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline_rounded), findsOneWidget);
  });

  test('PreferencesUtils bookmarks adds, checks, and removes IDs properly',
      () async {
    const testId = 999999;
    expect(await PreferencesUtils.isBookmarked(testId), isFalse);

    final added = await PreferencesUtils.toggleBookmark(testId);
    expect(added, isTrue);
    expect(await PreferencesUtils.isBookmarked(testId), isTrue);
    expect((await PreferencesUtils.getBookmarkIds()).contains(testId), isTrue);

    final removed = await PreferencesUtils.toggleBookmark(testId);
    expect(removed, isFalse);
    expect(await PreferencesUtils.isBookmarked(testId), isFalse);
  });

  testWidgets(
      'DetailsView renders filled bookmark icon when item was already bookmarked',
      (tester) async {
    const testMovieId = 550;
    await PreferencesUtils.addBookmark(testMovieId);

    final controller = Get.put(DetailsController());
    controller.isLoading.value = false;
    controller.errorMessage.value = '';
    controller.mediaId.value = testMovieId;
    await controller.checkBookmarkStatus();
    controller.detail.value = MediaDetailModel(
      id: testMovieId,
      mediaType: 'movie',
      title: 'Fight Club',
      tagline: 'Mischief. Mayhem. Soap.',
      overview: 'A ticking-time-bomb insomniac...',
      releaseDate: '1999-10-15',
      runtime: 139,
      voteAverage: 8.4,
      voteCount: 32000,
      status: 'Released',
      genres: [GenreModel(id: 18, name: 'Drama')],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const GetMaterialApp(
          home: DetailsView(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline_rounded), findsNothing);

    // Clean up
    await PreferencesUtils.removeBookmark(testMovieId);
  });

  testWidgets('WatchlistView renders empty state when no bookmarks exist',
      (tester) async {
    Get.put(WatchlistController());

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const GetMaterialApp(
          home: WatchlistView(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Watchlist'), findsOneWidget);
    expect(
      find.text('Your collection of saved movies and TV shows to watch'),
      findsOneWidget,
    );
    expect(find.text('Your Watchlist is Empty'), findsOneWidget);
    expect(find.text('Explore Movies'), findsOneWidget);
  });

  testWidgets('WatchlistView renders bookmarked items from local storage',
      (tester) async {
    const testMovieId = 8888;
    await PreferencesUtils.addBookmark(testMovieId, {
      'id': testMovieId,
      'title': 'Interstellar',
      'poster_path': '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      'media_type': 'movie',
      'vote_average': 8.7,
      'vote_count': 35000,
    });

    final controller = Get.put(WatchlistController());
    await controller.loadBookmarks();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => const GetMaterialApp(
          home: WatchlistView(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Interstellar'), findsOneWidget);
    expect(find.text('All (1)'), findsOneWidget);
    expect(find.text('Movies (1)'), findsOneWidget);

    // Clean up
    await PreferencesUtils.removeBookmark(testMovieId);
  });
}
