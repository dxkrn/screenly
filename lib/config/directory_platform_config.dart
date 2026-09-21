import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryPlatform {
  static Future<String> findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getApplicationDocumentsDirectory())
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
