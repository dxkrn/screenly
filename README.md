# Dxkrn App starter

Flutter Version: 3.38.3

Follow this:

## 📦 Change package name
- flutter pub run change_app_package_name:main com.new.package.name

## 📱 Change app name
- dart run rename_app:main all="My App Name"

## 🚀 Change launcher icon
- flutter pub run flutter_launcher_icons

## 🎨 Change theme or add more theme
- Go to lib/config/theme_config.dart
- Change / add colors on ThemeConfig class
- Change / add name of theme on AppTheme enum
- Use "ThemeConfig.switchTheme(AppTheme.<?>);" on spesified button

## 🇮🇩 Use Multi-language
- Add dictionary on assets/translations/<?>.json
- If without any args, use this:
  const Text('greeting').tr()
- If using positional args, use this:
  const Text('name').tr(
    args: ['Dicky', 'Magelang'],
  ),
- If using named args, use this:
  const Text('film').tr(
    namedArgs: {
        'title': 'Spiderman', 
        'genre': 'Sci-fi'
    }
  ),
- Use 3 lines bellow on spesified language button:
  const locale = Locale('id'); //change with defined Locale
  context.setLocale(locale);
  Get.updateLocale(locale);

## 📝 Change / Add Local Fonts
- Add .ttf or .otf fonts in assets/fonts/
- Update fonts family declaration on pubspec.yaml
- Update text style on lib/config/text_config.dart

## ⏳ Skeleton Loading
- https://pub.dev/packages/skeletonizer

## ☘️ Flavor
- 1. Wrap "GetMaterialApp" or "MaterialApp" with "FlavorBanner" widget
- 2. Create FlavorConfig in lib/ (e.g. main_dev.dart, main_prod.dart, main_staging.dart)
- 3. You can add another env variables in each FlavorConfig (inside "variables" props)
- 4. [Optional] Create method to get you env variable in lib/config/flavor_variables.dart
- 5. Call your variable anywhere using FlavorValues (e.g. FlavorValues.env) or directly call FlavorConfig (e.g. FlavorConfig.instance.variables["env"])
- 6. Run your app with an env you want using this command "flutter run -t lib/main_dev.dart"
- 7. Build your app using this command "flutter build apk -t lib/main_dev.dart"
