import 'package:get/get.dart';
import 'package:screenly/app/data/models/tvshow_airing_today_model.dart';
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/app/data/models/tvshow_popular_model.dart';
import 'package:screenly/app/data/models/tvshow_top_rated_model.dart';
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

  // NOTE: Popular state
  final isLoadingPopular = true.obs;
  final popularTvShows = <TvShowPopularModel>[].obs;
  final popularErrorMessage = ''.obs;

  // NOTE: Top Rated state
  final isLoadingTopRated = true.obs;
  final topRatedTvShows = <TvShowTopRatedModel>[].obs;
  final topRatedErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnTheAirTvShows();
    fetchAiringTodayTvShows();
    fetchPopularTvShows();
    fetchTopRatedTvShows();
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

  // NOTE: Fetch popular tv shows
  Future<void> fetchPopularTvShows() async {
    try {
      isLoadingPopular.value = true;
      popularErrorMessage.value = '';
      final response = await _tvShowService.getPopularTvShows();
      popularTvShows.assignAll(response.results);
    } catch (e) {
      popularErrorMessage.value = e.toString();
    } finally {
      isLoadingPopular.value = false;
    }
  }

  // NOTE: Fetch top rated tv shows
  Future<void> fetchTopRatedTvShows() async {
    try {
      isLoadingTopRated.value = true;
      topRatedErrorMessage.value = '';
      final response = await _tvShowService.getTopRatedTvShows();
      topRatedTvShows.assignAll(response.results);
    } catch (e) {
      topRatedErrorMessage.value = e.toString();
    } finally {
      isLoadingTopRated.value = false;
    }
  }
}
