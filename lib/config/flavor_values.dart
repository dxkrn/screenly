import 'package:flutter_flavor/flutter_flavor.dart';

class FlavorValues {
  static String get baseUrl =>
      FlavorConfig.instance.variables["baseUrl"] ?? "https://default.com";

  static String get env => FlavorConfig.instance.variables["env"] ?? "unknown";
}
