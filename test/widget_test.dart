import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenly/app/modules/movie/views/components/movie_card.dart';

void main() {
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
}
