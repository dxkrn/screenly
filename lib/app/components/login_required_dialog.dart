import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/modules/home/controllers/home_controller.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/config/size_config.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class LoginRequiredDialog {
  static Future<dynamic> show() {
    return Get.dialog(
      barrierColor: Colors.white.withValues(alpha: 0.05),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              width: deviceWidth - 32,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 23, 23, 23),
                  border: Border.all(
                    color: whiteColor.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: Colors.white38,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Login Required!',
                    style: heading5TextStyle.copyWith(color: whiteColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please connect your TMDB account to save items to your watchlist.',
                    textAlign: TextAlign.center,
                    style: paragraphSmallTextStyle.copyWith(
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Get.until((route) =>
                            route.settings.name == Routes.HOME ||
                            route.isFirst);
                        if (Get.isRegistered<HomeController>()) {
                          Get.find<HomeController>().changeTabIndex(3);
                        }
                      },
                      icon: const Icon(Icons.cloud_sync_rounded, size: 18),
                      label: Text(
                        'Connect TMDB Account',
                        style: heading6TextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
