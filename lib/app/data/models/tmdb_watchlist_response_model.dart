import 'package:screenly/app/data/models/search_multi_model.dart';

class TmdbWatchlistResponseModel {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<SearchResultModel> results;

  TmdbWatchlistResponseModel({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  factory TmdbWatchlistResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? defaultMediaType,
  }) {
    final rawResults = json['results'] as List<dynamic>? ?? [];
    final items = rawResults.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      if (defaultMediaType != null && map['media_type'] == null) {
        map['media_type'] = defaultMediaType;
      }
      return SearchResultModel.fromJson(map);
    }).toList();

    return TmdbWatchlistResponseModel(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
      results: items,
    );
  }
}
