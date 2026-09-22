import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';
import 'package:screenly/app/modules/profile/views/profile_view.dart';
import 'package:screenly/app/modules/watchlist/views/watchlist_view.dart';
import '../controllers/home_controller.dart';
import 'components/home_bottom_nav_bar.dart';
import 'sections/home_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeSection(),
      const DiscoverView(),
      const WatchlistView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
