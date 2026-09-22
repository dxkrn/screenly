import 'package:get/get.dart';
import 'package:screenly/app/data/models/media_detail_model.dart';
import 'package:screenly/app/data/services/tmdb_movie_service.dart';
import 'package:screenly/app/data/services/tmdb_tvshow_service.dart';

class DetailsController extends GetxController {
  final TmdbService _movieService = TmdbService();
  final TmdbTvShowService _tvShowService = TmdbTvShowService();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final detail = Rxn<MediaDetailModel>();

  final mediaId = 0.obs;
  final mediaType = 'movie'.obs; // 'movie' or 'tv'

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    fetchDetails();
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['id'] != null) {
        mediaId.value = (args['id'] as num).toInt();
      }
      if (args['type'] != null) {
        mediaType.value = args['type'].toString().toLowerCase();
      }
    } else if (args is int) {
      mediaId.value = args;
    }
  }

  Future<void> fetchDetails() async {
    if (mediaId.value <= 0) {
      errorMessage.value = 'Invalid media ID';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (mediaType.value == 'tv') {
        final result = await _tvShowService.getTvShowDetail(mediaId.value);
        detail.value = result;
      } else {
        final result = await _movieService.getMovieDetail(mediaId.value);
        detail.value = result;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() {
    fetchDetails();
  }
}
