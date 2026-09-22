import 'package:get/get.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';

class TvshowController extends GetxController {
  final TmdbTvShowService _tvShowService = TmdbTvShowService();

  // NOTE: On The Air state
  final isLoadingOnTheAir = true.obs;
  final onTheAirTvShows = <TvShowOnTheAirModel>[].obs;
  final onTheAirErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnTheAirTvShows();
  }

  // NOTE: Fetch on the air tv shows
  Future<void> fetchOnTheAirTvShows() async {
    try {
      isLoadingOnTheAir.value = true;
      onTheAirErrorMessage.value = '';
      final response = await _tvShowService.getOnTheAirTvShows();
      onTheAirTvShows.assignAll(response.results);
    } catch (e) {
      onTheAirErrorMessage.value = e.toString();
    } finally {
      isLoadingOnTheAir.value = false;
    }
  }
}
