import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/search_multi_model.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/modules/discover/controllers/discover_controller.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';
import 'package:screenly/app/modules/movie/views/components/populer_people_card.dart';

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
}
