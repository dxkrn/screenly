import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/models/tvshow_airing_today_model.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/data/models/tvshow_popular_model.dart';
import 'package:screenly/app/data/models/tvshow_top_rated_model.dart';
import 'package:screenly/app/modules/discover/controllers/discover_controller.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/movie/views/components/populer_people_card.dart';
import 'package:screenly/app/modules/tvshow/views/components/tvshow_card.dart';

void main() {
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
}
