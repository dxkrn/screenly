import 'package:get/get.dart';
import 'package:screenly/app/modules/discover/controllers/discover_controller.dart';
import 'package:screenly/app/modules/movie/controllers/movie_controller.dart';
import 'package:screenly/app/modules/profile/controllers/profile_controller.dart';
import 'package:screenly/app/modules/tvshow/controllers/tvshow_controller.dart';
import 'package:screenly/app/modules/watchlist/controllers/watchlist_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<DiscoverController>(
      () => DiscoverController(),
    );
    Get.lazyPut<WatchlistController>(
      () => WatchlistController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<MovieController>(
      () => MovieController(),
    );
    Get.lazyPut<TvshowController>(
      () => TvshowController(),
    );
  }
}
