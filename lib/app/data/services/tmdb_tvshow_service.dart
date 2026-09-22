import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screenly/app/data/models/tvshow_on_the_air_model.dart';
import 'package:screenly/config/api_config.dart';

class TmdbTvShowService {
  final http.Client _client;

  TmdbTvShowService({http.Client? client}) : _client = client ?? http.Client();

  // NOTE: get on the air tv shows
  Future<TvShowOnTheAirResponseModel> getOnTheAirTvShows({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/tv/on_the_air?language=en-US&page=$page',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return TvShowOnTheAirResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load on the air TV shows (Status: ${response.statusCode})',
      );
    }
  }
}
