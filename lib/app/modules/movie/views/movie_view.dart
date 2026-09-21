import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/movie/views/sections/now_playing_section.dart';
import '../controllers/movie_controller.dart';

class MovieView extends GetView<MovieController> {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            NowPlayingSection(),
          ],
        ),
      )),
    );
  }
}
