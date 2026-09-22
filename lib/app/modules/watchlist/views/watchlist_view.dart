import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

import '../controllers/watchlist_controller.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'WatchlistView',
          style: heading4TextStyle.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}
