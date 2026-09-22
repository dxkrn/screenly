// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

class PreferencesUtils {
  static const HIVE_BOX = "DxBox";
  static const HIVE_THEME = "Theme";
  static const HIVE_AUTH = "UserAuth";
  static const HIVE_BOOKMARKS = "Bookmarks";
  static const HIVE_BOOKMARK_ITEMS = "BookmarkItems";

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

  // Note: Bookmarks
  static Future<List<int>> getBookmarkIds() async {
    var box = await Hive.openBox(HIVE_BOX);
    final rawList = box.get(HIVE_BOOKMARKS);
    if (rawList is List) {
      return rawList
          .map((e) => int.tryParse(e.toString()) ?? 0)
          .where((id) => id > 0)
          .toList();
    }
    return <int>[];
  }

  static Future<List<Map<String, dynamic>>> getBookmarkItems() async {
    var box = await Hive.openBox(HIVE_BOX);
    final bookmarkIds = await getBookmarkIds();
    final rawItems = box.get(HIVE_BOOKMARK_ITEMS);
    Map<String, dynamic> itemsMap = {};
    if (rawItems is Map) {
      itemsMap = Map<String, dynamic>.from(rawItems);
    }

    final List<Map<String, dynamic>> items = [];
    for (final id in bookmarkIds.reversed) {
      final item = itemsMap[id.toString()];
      if (item is Map) {
        items.add(Map<String, dynamic>.from(item));
      } else {
        items.add({'id': id});
      }
    }
    return items;
  }

  static Future<bool> isBookmarked(int id) async {
    if (id <= 0) return false;
    final bookmarks = await getBookmarkIds();
    return bookmarks.contains(id);
  }

  static Future<bool> toggleBookmark(
    int id, [
    Map<String, dynamic>? itemData,
  ]) async {
    if (id <= 0) return false;
    var box = await Hive.openBox(HIVE_BOX);
    final rawList = box.get(HIVE_BOOKMARKS);
    List<int> bookmarks = [];
    if (rawList is List) {
      bookmarks = rawList
          .map((e) => int.tryParse(e.toString()) ?? 0)
          .where((item) => item > 0)
          .toList();
    }

    final isAlreadyBookmarked = bookmarks.contains(id);
    if (isAlreadyBookmarked) {
      bookmarks.remove(id);
    } else {
      bookmarks.add(id);
    }
    await box.put(HIVE_BOOKMARKS, bookmarks);

    if (itemData != null || isAlreadyBookmarked) {
      final rawItems = box.get(HIVE_BOOKMARK_ITEMS);
      Map<String, dynamic> itemsMap = {};
      if (rawItems is Map) {
        itemsMap = Map<String, dynamic>.from(rawItems);
      }
      if (isAlreadyBookmarked) {
        itemsMap.remove(id.toString());
      } else if (itemData != null) {
        itemsMap[id.toString()] = itemData;
      }
      await box.put(HIVE_BOOKMARK_ITEMS, itemsMap);
    }

    return !isAlreadyBookmarked;
  }

  static Future<void> addBookmark(
    int id, [
    Map<String, dynamic>? itemData,
  ]) async {
    if (id <= 0) return;
    var box = await Hive.openBox(HIVE_BOX);
    final bookmarks = await getBookmarkIds();
    if (!bookmarks.contains(id)) {
      bookmarks.add(id);
      await box.put(HIVE_BOOKMARKS, bookmarks);
      if (itemData != null) {
        final rawItems = box.get(HIVE_BOOKMARK_ITEMS);
        Map<String, dynamic> itemsMap = {};
        if (rawItems is Map) {
          itemsMap = Map<String, dynamic>.from(rawItems);
        }
        itemsMap[id.toString()] = itemData;
        await box.put(HIVE_BOOKMARK_ITEMS, itemsMap);
      }
    }
  }

  static Future<void> removeBookmark(int id) async {
    if (id <= 0) return;
    var box = await Hive.openBox(HIVE_BOX);
    final bookmarks = await getBookmarkIds();
    if (bookmarks.contains(id)) {
      bookmarks.remove(id);
      await box.put(HIVE_BOOKMARKS, bookmarks);
      final rawItems = box.get(HIVE_BOOKMARK_ITEMS);
      if (rawItems is Map) {
        final itemsMap = Map<String, dynamic>.from(rawItems);
        itemsMap.remove(id.toString());
        await box.put(HIVE_BOOKMARK_ITEMS, itemsMap);
      }
    }
  }
}
