import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/movie/views/sections/now_playing_section.dart';
import 'package:screenly/app/modules/movie/views/sections/popular_section.dart';
import 'package:screenly/app/modules/movie/views/sections/top_rated_section.dart';
import '../controllers/movie_controller.dart';
import 'sections/upcoming_section.dart';

class MovieView extends GetView<MovieController> {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          spacing: 32,
          children: [
            NowPlayingSection(),
            UpcomingSection(),
            TopRatedSection(),
            PopularSection(),
          ],
        ),
      )),
    );
  }
}
