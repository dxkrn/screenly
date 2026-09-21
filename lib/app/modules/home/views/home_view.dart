import 'package:screenly/config/flavor_values.dart';
import 'package:screenly/utils/extensions/space_extension.dart';
import 'package:screenly/utils/helpers/screensize_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:screenly/app/components/custom_network_image.dart';
import 'package:screenly/app/components/skeleton_loader.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import 'package:screenly/utils/helpers/path_helper.dart';
import 'package:screenly/utils/preferences_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeC = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          // NOTE: how to trigger SkeletonLoader
          ElevatedButton(
            onPressed: () {
              homeC.isLoading.value = !homeC.isLoading.value;
            },
            child: const Text('ON/OF Loading'),
          ),
        ],
      ),
      body: Obx(
        () => SkeletonLoader(
          // NOTE: how to use SkeletonLoader easily
          enabled: homeC.isLoading.value,
          child: ListView(
            children: [
              // NOTE: for responsive and adaptive widget builder (sm, md, and lg screen)
              Builder(builder: (context) {
                switch (getScreenSize()) {
                  case ScreenSize.small:
                    return Text(
                      'Small Screen',
                      style: TextStyle(fontSize: 14.sp),
                    );
                  case ScreenSize.medium:
                    return Text(
                      'Medium Screen',
                      style: TextStyle(fontSize: 18.sp),
                    );
                  case ScreenSize.large:
                    return Text(
                      'Large Screen',
                      style: TextStyle(fontSize: 22.sp),
                    );
                }
              }),

              // NOTE: for Network Image, using cached network image inside
              const CustomNetworkImage(
                imgUrl:
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png",
              ),

              // NOTE: how to use lottie
              Lottie.asset(setLottiePath('logo')),

              // NOTE: how to save and load local data, using HIVE inside
              ElevatedButton(
                onPressed: () {
                  PreferencesUtils.addUser('Dxkrn');
                },
                child: const Text('Save Data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? user = await PreferencesUtils.getUser();
                  debugPrint('USER: $user');
                },
                child: const Text('Print Data'),
              ),

              const Divider(),

              // NOTE: how to implement multi-language
              Text(
                'greeting',
                style: heading1TextStyle,
              ).tr(),
              const Text('name').tr(
                args: ['Dicky', 'Magelang'],
              ),
              const Text('film')
                  .tr(namedArgs: {'title': 'Spiderman', 'genre': 'Sci-fi'}),
              const Text('characters').tr(gender: 'male'),
              ElevatedButton(
                onPressed: () {
                  const locale = Locale('id');
                  context.setLocale(locale);
                  Get.updateLocale(locale);
                },
                child: const Text('🇮🇩'),
              ),
              ElevatedButton(
                onPressed: () {
                  const locale = Locale('en', 'US');
                  context.setLocale(locale);
                  Get.updateLocale(locale);
                },
                child: const Text('🇺🇸'),
              ),

              // Note: how to use multi-theme
              Container(
                width: 100,
                height: 100,
                color: primaryColor,
              ),
              ElevatedButton(
                onPressed: () {
                  ThemeConfig.switchTheme(AppTheme.light);
                },
                child: const Text('Theme Light'),
              ),
              ElevatedButton(
                onPressed: () {
                  ThemeConfig.switchTheme(AppTheme.dark);
                },
                child: const Text('Theme Dark'),
              ),

              // NOTE: How to use Flavor
              Text("CURRENT ENVIRONMENT"),
              Text("Name: ${FlavorValues.env}"),
              Text("BaseUrl: ${FlavorValues.baseUrl}"),
              40.height,
            ],
          ),
        ),
      ),
    );
  }
}
