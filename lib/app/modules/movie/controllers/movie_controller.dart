import 'package:get/get.dart';
import 'package:screenly/app/data/models/movie_now_playing_model.dart';
import 'package:screenly/app/data/models/movie_top_rated_model.dart';
import 'package:screenly/app/data/models/movie_upcoming_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';

class MovieController extends GetxController {
  final TmdbService _tmdbService = TmdbService();

  // NOTE: Now Playing state
  final isLoadingNowPlaying = true.obs;
  final nowPlayingMovies = <MovieNowPlayingModel>[].obs;
  final errorMessage = ''.obs;

  // NOTE: Upcoming state
  final isLoadingUpcoming = true.obs;
  final upcomingMovies = <MovieUpcomingModel>[].obs;
  final upcomingErrorMessage = ''.obs;

  // NOTE: Top Rated state
  final isLoadingTopRated = true.obs;
  final topRatedMovies = <MovieTopRatedModel>[].obs;
  final topRatedErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNowPlayingMovies();
    fetchUpcomingMovies();
    fetchTopRatedMovies();
  }

  // NOTE: Fetch now playing movies
  Future<void> fetchNowPlayingMovies() async {
    try {
      isLoadingNowPlaying.value = true;
      errorMessage.value = '';
      final response = await _tmdbService.getNowPlayingMovies();
      nowPlayingMovies.assignAll(response.results);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingNowPlaying.value = false;
    }
  }

  // NOTE: Fetch upcoming movies
  Future<void> fetchUpcomingMovies() async {
    try {
      isLoadingUpcoming.value = true;
      upcomingErrorMessage.value = '';
      final response = await _tmdbService.getUpcomingMovies();
      upcomingMovies.assignAll(response.results);
    } catch (e) {
      upcomingErrorMessage.value = e.toString();
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  // NOTE: Fetch top rated movies
  Future<void> fetchTopRatedMovies() async {
    try {
      isLoadingTopRated.value = true;
      topRatedErrorMessage.value = '';
      final response = await _tmdbService.getTopRatedMovies();
      topRatedMovies.assignAll(response.results);
    } catch (e) {
      topRatedErrorMessage.value = e.toString();
    } finally {
      isLoadingTopRated.value = false;
    }
  }
}
