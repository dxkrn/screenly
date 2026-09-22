import 'package:screenly/config/api_config.dart';

class MovieUpcomingModel {
  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<dynamic>? genreIds;

  MovieUpcomingModel({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genreIds,
  });

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

  factory MovieUpcomingModel.fromJson(Map<String, dynamic> json) {
    return MovieUpcomingModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      genreIds: json['genre_ids'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
    };
  }
}

class MovieUpcomingResponseModel {
  final int page;
  final List<MovieUpcomingModel> results;
  final int? totalPages;
  final int? totalResults;

  MovieUpcomingResponseModel({
    required this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieUpcomingResponseModel.fromJson(Map<String, dynamic> json) {
    return MovieUpcomingResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((item) =>
                  MovieUpcomingModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }
}
