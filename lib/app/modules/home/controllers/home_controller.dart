// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  final selectedIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void changeCategoryIndex(int index) {
    selectedCategoryIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
