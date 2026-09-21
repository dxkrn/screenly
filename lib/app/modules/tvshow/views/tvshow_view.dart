import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tvshow_controller.dart';

class TvshowView extends GetView<TvshowController> {
  const TvshowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      )),
    );
  }
}
