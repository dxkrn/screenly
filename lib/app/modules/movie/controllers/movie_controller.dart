import 'package:get/get.dart';
import 'package:screenly/app/data/models/movie_now_playing_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';

class MovieController extends GetxController {
  final TmdbService _tmdbService = TmdbService();

  final isLoadingNowPlaying = true.obs;
  final nowPlayingMovies = <MovieNowPlayingModel>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNowPlayingMovies();
  }

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
}
