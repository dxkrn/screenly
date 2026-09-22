import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  const DiscoverView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Search',
          style: heading4TextStyle.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}
