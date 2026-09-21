// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

class PreferencesUtils {
  static const HIVE_BOX = "DxBox";
  static const HIVE_THEME = "Theme";
  static const HIVE_AUTH = "UserAuth";

  // Note: User Data
  static Future<void> addTheme(String data) async {
    var box = await Hive.openBox(HIVE_BOX);
    await box.put(HIVE_THEME, data);
  }

  static Future<String?> getTheme() async {
    var box = await Hive.openBox(HIVE_BOX);
    return box.get(HIVE_THEME);
  }

  // Note: User Data
  static Future<void> addUser(String data) async {
    var box = await Hive.openBox(HIVE_BOX);
    await box.put(HIVE_AUTH, data);
  }

  static Future<String?> getUser() async {
    var box = await Hive.openBox(HIVE_BOX);
    return box.get(HIVE_AUTH);
  }

  static Future<void> deleteUser() async {
    var box = await Hive.openBox(HIVE_BOX);
    return box.delete(HIVE_AUTH);
  }
}
