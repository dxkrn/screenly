import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:screenly/app/modules/splash/bindings/splash_binding.dart';
import 'package:screenly/config/directory_platform_config.dart';
import 'package:screenly/config/theme_config.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Multi Language
  await EasyLocalization.ensureInitialized();

  // Local Storage
  var path = await DirectoryPlatform.findLocalPath();
  Hive.init(path);

  // Theme
  await ThemeConfig.getCurrentTheme();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('id'),
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('id'),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => _buildAppWithFlavorBanner(context),
      ),
    ),
  );
}

Widget _buildAppWithFlavorBanner(BuildContext context) {
  final app = GetMaterialApp(
    title: "Application",
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    debugShowCheckedModeBanner: false,
    initialBinding: SplashBinding(),
    theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color.fromARGB(221, 21, 20, 20)),
  );

  // NOTE: Hide Banner in PROD flavor
  if (FlavorConfig.instance.name == "PROD") {
    return app;
  }

  return FlavorBanner(child: app);
}
