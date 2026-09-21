import 'package:get/get.dart';

import '../controllers/tvshow_controller.dart';

class TvshowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TvshowController>(
      () => TvshowController(),
    );
  }
}
