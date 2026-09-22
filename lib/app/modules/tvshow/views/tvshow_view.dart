import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tvshow_controller.dart';
import 'sections/on_the_air_section.dart';

class TvshowView extends GetView<TvshowController> {
  const TvshowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            OnTheAirSection(),
          ],
        ),
      )),
    );
  }
}
