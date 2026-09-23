import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screenly/app/data/models/tmdb_watchlist_response_model.dart';
import 'package:screenly/config/api_config.dart';

class TmdbWatchlistService {
  final http.Client _client;

  TmdbWatchlistService({http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> get _jsonHeaders => {
        ...ApiConfig.tmdbHeaders,
        'Content-Type': 'application/json',
      };

  Future<bool> updateWatchlist({
    required int accountId,
    required String sessionId,
    required String mediaType,
    required int mediaId,
    required bool watchlist,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/account/$accountId/watchlist?session_id=$sessionId',
    );

    final response = await _client.post(
      uri,
      headers: _jsonHeaders,
      body: json.encode({
        'media_type': mediaType,
        'media_id': mediaId,
        'watchlist': watchlist,
      }),
    );

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final statusCode = data['status_code'] as int? ?? 1;
      // TMDB status codes: 1 = Success, 12 = Item updated, 13 = Item deleted
      return statusCode == 1 || statusCode == 12 || statusCode == 13;
    } else {
      final message =
          data['status_message'] ?? 'Failed to update TMDB watchlist';
      throw Exception(message);
    }
  }

  Future<TmdbWatchlistResponseModel> getWatchlistMovies({
    required int accountId,
    required String sessionId,
    int page = 1,
    String sortBy = 'created_at.desc',
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/account/$accountId/watchlist/movies?session_id=$sessionId&page=$page&sort_by=$sortBy',
    );

    final response = await _client.get(uri, headers: ApiConfig.tmdbHeaders);

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return TmdbWatchlistResponseModel.fromJson(data,
          defaultMediaType: 'movie');
    } else {
      final message =
          data['status_message'] ?? 'Failed to fetch watchlist movies';
      throw Exception(message);
    }
  }

  Future<TmdbWatchlistResponseModel> getWatchlistTvShows({
    required int accountId,
    required String sessionId,
    int page = 1,
    String sortBy = 'created_at.desc',
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/account/$accountId/watchlist/tv?session_id=$sessionId&page=$page&sort_by=$sortBy',
    );

    final response = await _client.get(uri, headers: ApiConfig.tmdbHeaders);

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return TmdbWatchlistResponseModel.fromJson(data, defaultMediaType: 'tv');
    } else {
      final message =
          data['status_message'] ?? 'Failed to fetch watchlist TV shows';
      throw Exception(message);
    }
  }

  Future<bool> isItemInWatchlist({
    required int mediaId,
    required String mediaType,
    required String sessionId,
  }) async {
    final endpoint = mediaType.toLowerCase() == 'tv' ? 'tv' : 'movie';
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/$endpoint/$mediaId/account_states?session_id=$sessionId',
    );

    try {
      final response = await _client.get(uri, headers: ApiConfig.tmdbHeaders);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        return data['watchlist'] == true;
      }
    } catch (_) {}
    return false;
  }
}
