// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:screenly/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 2700), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
