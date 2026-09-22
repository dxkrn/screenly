import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../components/movie_card.dart';

class PopularSection extends StatelessWidget {
  const PopularSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Movies',
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 8,
                children: [
                  MovieCard(),
                  MovieCard(),
                  MovieCard(),
                  MovieCard(),
                  MovieCard(),
                ],
              )),
        ),
      ],
    );
  }
}
