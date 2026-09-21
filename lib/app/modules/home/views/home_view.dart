import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.MOVIE);
                },
                child: Text('Movie')),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.TVSHOW);
                },
                child: Text('TV')),
          ],
        ),
      )),
    );
  }
}
