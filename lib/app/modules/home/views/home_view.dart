import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:screenly/app/modules/discover/views/discover_view.dart';
import 'package:screenly/app/modules/profile/views/profile_view.dart';
import 'package:screenly/app/modules/watchlist/views/watchlist_view.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.MOVIE);
                },
                child: const Text('Movie'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.TVSHOW);
                },
                child: const Text('TV'),
              ),
            ],
          ),
        ),
      ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(
              () => GNav(
                rippleColor: primaryColor.withValues(alpha: 0.2),
                hoverColor: primaryColor.withValues(alpha: 0.1),
                gap: 8,
                activeColor: primaryColor,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                duration: const Duration(milliseconds: 300),
                tabBackgroundColor: primaryColor.withValues(alpha: 0.15),
                color: Colors.grey,
                selectedIndex: controller.selectedIndex.value,
                onTabChange: controller.changeTabIndex,
                tabs: const [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search_rounded,
                    text: 'Discover',
                  ),
                  GButton(
                    icon: Icons.bookmark_rounded,
                    text: 'WatchList',
                  ),
                  GButton(
                    icon: Icons.person_rounded,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
