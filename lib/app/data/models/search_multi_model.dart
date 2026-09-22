import 'package:screenly/config/api_config.dart';

class SearchResultModel {
  final int id;
  final String? mediaType;
  final String? title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final List<dynamic>? genreIds;

  SearchResultModel({
    required this.id,
    this.mediaType,
    this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.popularity,
    this.genreIds,
  });

  bool get isMovie => mediaType == 'movie';
  bool get isTv => mediaType == 'tv';
  bool get isPerson => mediaType == 'person';
  bool get isMovieOrTv => isMovie || isTv;

  String get displayTitle => title ?? originalTitle ?? 'Untitled';

  String get fullPosterUrl => posterPath != null && posterPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w500$posterPath'
      : '';

  String get fullBackdropUrl => backdropPath != null && backdropPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w780$backdropPath'
      : '';

  String get releaseYear {
    if (releaseDate != null && releaseDate!.isNotEmpty) {
      return releaseDate!.split('-').first;
    }
    return '';
  }

  String get formattedRating {
    if (voteAverage != null && voteAverage! > 0) {
      return voteAverage!.toStringAsFixed(1);
    }
    return 'N/A';
  }

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] as int? ?? 0,
      mediaType: json['media_type'] as String?,
      title: (json['title'] ?? json['name']) as String?,
      originalTitle:
          (json['original_title'] ?? json['original_name']) as String?,
      overview: json['overview'] as String?,
      posterPath: (json['poster_path'] ?? json['profile_path']) as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      genreIds: json['genre_ids'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'genre_ids': genreIds,
    };
  }
}

class SearchMultiResponseModel {
  final int page;
  final List<SearchResultModel> results;
  final int? totalPages;
  final int? totalResults;

  SearchMultiResponseModel({
    required this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory SearchMultiResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchMultiResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((item) =>
                  SearchResultModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }
}
