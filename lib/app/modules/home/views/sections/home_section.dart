import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/movie/views/movie_view.dart';
import 'package:screenly/app/modules/tvshow/views/tvshow_view.dart';
import '../../controllers/home_controller.dart';
import '../components/coming_soon_view.dart';
import 'category_tab_section.dart';

class HomeSection extends GetView<HomeController> {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryTabSection(),
          Expanded(
            child: Obx(() {
              switch (controller.selectedCategoryIndex.value) {
                case 0:
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: const MovieView(),
                  );
                case 1:
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: const TvshowView(),
                  );
                default:
                  final category = CategoryTabSection
                      .categories[controller.selectedCategoryIndex.value];
                  return ComingSoonView(title: category.title);
              }
            }),
          ),
        ],
      ),
    );
  }
}
