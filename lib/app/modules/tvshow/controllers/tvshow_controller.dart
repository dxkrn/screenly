import 'package:get/get.dart';
import 'package:screenly/app/data/models/tvshow_airing_today_model.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';

class TvshowController extends GetxController {
  final TmdbTvShowService _tvShowService = TmdbTvShowService();

  // NOTE: On The Air state
  final isLoadingOnTheAir = true.obs;
  final onTheAirTvShows = <TvShowOnTheAirModel>[].obs;
  final onTheAirErrorMessage = ''.obs;

  // NOTE: Airing Today state
  final isLoadingAiringToday = true.obs;
  final airingTodayTvShows = <TvShowAiringTodayModel>[].obs;
  final airingTodayErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnTheAirTvShows();
    fetchAiringTodayTvShows();
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

  // NOTE: Fetch airing today tv shows
  Future<void> fetchAiringTodayTvShows() async {
    try {
      isLoadingAiringToday.value = true;
      airingTodayErrorMessage.value = '';
      final response = await _tvShowService.getAiringTodayTvShows();
      airingTodayTvShows.assignAll(response.results);
    } catch (e) {
      airingTodayErrorMessage.value = e.toString();
    } finally {
      isLoadingAiringToday.value = false;
    }
  }
}
