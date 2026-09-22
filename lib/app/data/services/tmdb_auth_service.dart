import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screenly/app/data/models/tmdb_account_model.dart';
import 'package:screenly/config/api_config.dart';

class TmdbAuthService {
  final http.Client _client;

  TmdbAuthService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _jsonHeaders => {
        ...ApiConfig.tmdbHeaders,
        'Content-Type': 'application/json',
      };

  /// Step 1: Create a new request token
  Future<String> createRequestToken() async {
    final uri = Uri.parse('${ApiConfig.tmdbBaseUrl}/authentication/token/new');
    final response = await _client.get(uri, headers: ApiConfig.tmdbHeaders);

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return data['request_token'] as String;
    } else {
      final message =
          data['status_message'] ?? 'Failed to generate request token';
      throw Exception(message);
    }
  }

  static const String authCallbackScheme = 'screenly';
  static const String authCallbackHost = 'approved';
  static const String defaultRedirectUrl = 'screenly://approved';

  /// Build TMDB authorization URL for browser approval
  Uri buildAuthUrl(
    String requestToken, {
    String? redirectTo = defaultRedirectUrl,
  }) {
    final queryParams = <String, String>{};
    if (redirectTo != null && redirectTo.isNotEmpty) {
      queryParams['redirect_to'] = redirectTo;
    }
    return Uri.https(
      'www.themoviedb.org',
      '/authenticate/$requestToken',
      queryParams.isEmpty ? null : queryParams,
    );
  }

  /// Step 2: Validate the request token with user's TMDB username & password
  Future<String> validateWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/authentication/token/validate_with_login',
    );
    final response = await _client.post(
      uri,
      headers: _jsonHeaders,
      body: json.encode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
    );

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return data['request_token'] as String;
    } else {
      final message =
          data['status_message'] ?? 'Invalid TMDB username or password';
      throw Exception(message);
    }
  }

  /// Step 3: Create a session ID using the validated request token
  Future<String> createSession({required String requestToken}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/authentication/session/new',
    );
    final response = await _client.post(
      uri,
      headers: _jsonHeaders,
      body: json.encode({
        'request_token': requestToken,
      }),
    );

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] == true) {
      return data['session_id'] as String;
    } else {
      final message = data['status_message'] ?? 'Failed to create TMDB session';
      throw Exception(message);
    }
  }

  /// Step 4: Fetch account details for the session
  Future<TmdbAccountModel> getAccountDetails({
    required String sessionId,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/account?session_id=$sessionId',
    );
    final response = await _client.get(uri, headers: ApiConfig.tmdbHeaders);

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['id'] != null) {
      return TmdbAccountModel.fromJson(data);
    } else {
      final message =
          data['status_message'] ?? 'Failed to fetch account details';
      throw Exception(message);
    }
  }

  /// Step 5: Delete / Invalidate the session (Logout)
  Future<bool> deleteSession({required String sessionId}) async {
    final uri = Uri.parse(
      '${ApiConfig.tmdbBaseUrl}/authentication/session',
    );
    final response = await _client.delete(
      uri,
      headers: _jsonHeaders,
      body: json.encode({
        'session_id': sessionId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      return data['success'] == true;
    }
    return false;
  }
}
