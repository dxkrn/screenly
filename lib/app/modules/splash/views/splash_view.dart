import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:screenly/config/theme_config.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: primaryColor,
          child: const Text(
            'Splash',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
