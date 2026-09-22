import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../components/category_tab_item.dart';

class CategoryItemData {
  final String title;
  final bool isAvailable;

  const CategoryItemData({
    required this.title,
    this.isAvailable = true,
  });
}

class CategoryTabSection extends GetView<HomeController> {
  const CategoryTabSection({super.key});

  static const List<CategoryItemData> categories = [
    CategoryItemData(title: 'Movies', isAvailable: true),
    CategoryItemData(title: 'TV Shows', isAvailable: true),
    CategoryItemData(title: 'Cartoons', isAvailable: false),
    CategoryItemData(title: 'Series', isAvailable: false),
    CategoryItemData(title: 'K-dramas', isAvailable: false),
    CategoryItemData(title: 'C-dramas', isAvailable: false),
    CategoryItemData(title: 'Podcasts', isAvailable: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return Obx(() {
              final isSelected =
                  controller.selectedCategoryIndex.value == index;
              return CategoryTabItem(
                title: category.title,
                isSelected: isSelected,
                isAvailable: category.isAvailable,
                onTap: () {
                  controller.changeCategoryIndex(index);
                },
              );
            });
          }),
        ),
      ),
    );
  }
}
