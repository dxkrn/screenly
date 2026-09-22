import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screenly/app/data/models/movie_now_playing_model.dart';
import 'package:screenly/app/data/models/movie_popular_model.dart';
import 'package:screenly/app/data/models/movie_top_rated_model.dart';
import 'package:screenly/app/data/models/movie_upcoming_model.dart';
import 'package:screenly/config/api_config.dart';

class TmdbService {
  final http.Client _client;

  TmdbService({http.Client? client}) : _client = client ?? http.Client();

  // NOTE: get now playing movies
  Future<MovieResponseModel> getNowPlayingMovies({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/movie/now_playing?language=en-US&page=$page',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return MovieResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load now playing movies (Status: ${response.statusCode})',
      );
    }
  }

  // NOTE: get detail movie
  Future<MovieNowPlayingModel> getMovieDetail(int movieId) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/movie/$movieId?language=en-US',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return MovieNowPlayingModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load movie detail for ID: $movieId (Status: ${response.statusCode})',
      );
    }
  }

  // NOTE: get upcoming movies
  Future<MovieUpcomingResponseModel> getUpcomingMovies({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/movie/upcoming?language=en-US&page=$page',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return MovieUpcomingResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load upcoming movies (Status: ${response.statusCode})',
      );
    }
  }

  // NOTE: get top rated movies
  Future<MovieTopRatedResponseModel> getTopRatedMovies({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/movie/top_rated?language=en-US&page=$page',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return MovieTopRatedResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load top rated movies (Status: ${response.statusCode})',
      );
    }
  }

  // NOTE: get popular movies
  Future<MoviePopularResponseModel> getPopularMovies({int page = 1}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/movie/popular?language=en-US&page=$page',
    );

    final response = await _client.get(
      uri,
      headers: ApiConfig.tmdbHeaders,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return MoviePopularResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load popular movies (Status: ${response.statusCode})',
      );
    }
  }
}
