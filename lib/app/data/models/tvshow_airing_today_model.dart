import 'package:screenly/config/api_config.dart';

class TvShowAiringTodayModel {
  final int id;
  final String name;
  final String? originalName;
  final String? firstAirDate;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final String? overview;
  final double? popularity;
  final List<dynamic>? originCountry;
  final List<dynamic>? genreIds;
  final String? originalLanguage;

  TvShowAiringTodayModel({
    required this.id,
    required this.name,
    this.originalName,
    this.firstAirDate,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.overview,
    this.popularity,
    this.originCountry,
    this.genreIds,
    this.originalLanguage,
  });

  String get title => name;

  String get fullPosterUrl => posterPath != null && posterPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w500$posterPath'
      : '';

  String get fullBackdropUrl => backdropPath != null && backdropPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w780$backdropPath'
      : '';

  String get releaseYear {
    if (firstAirDate != null && firstAirDate!.isNotEmpty) {
      return firstAirDate!.split('-').first;
    }
    return '';
  }

  String get formattedRating {
    if (voteAverage != null && voteAverage! > 0) {
      return voteAverage!.toStringAsFixed(1);
    }
    return 'N/A';
  }

  factory TvShowAiringTodayModel.fromJson(Map<String, dynamic> json) {
    return TvShowAiringTodayModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      originalName: json['original_name'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      originCountry: json['origin_country'] as List<dynamic>?,
      genreIds: json['genre_ids'] as List<dynamic>?,
      originalLanguage: json['original_language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'original_name': originalName,
      'first_air_date': firstAirDate,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'overview': overview,
      'popularity': popularity,
      'origin_country': originCountry,
      'genre_ids': genreIds,
      'original_language': originalLanguage,
    };
  }
}

class TvShowAiringTodayResponseModel {
  final int page;
  final List<TvShowAiringTodayModel> results;
  final int? totalPages;
  final int? totalResults;

  TvShowAiringTodayResponseModel({
    required this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory TvShowAiringTodayResponseModel.fromJson(Map<String, dynamic> json) {
    return TvShowAiringTodayResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  TvShowAiringTodayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results.map((e) => e.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}
