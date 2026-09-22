import 'package:screenly/config/api_config.dart';

class GenreModel {
  final int id;
  final String name;

  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ProductionCompanyModel {
  final int id;
  final String name;
  final String? logoPath;
  final String? originCountry;

  ProductionCompanyModel({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });

  String get fullLogoUrl => logoPath != null && logoPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w300$logoPath'
      : '';

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logoPath: json['logo_path'] as String?,
      originCountry: json['origin_country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_path': logoPath,
        'origin_country': originCountry,
      };
}

class ProductionCountryModel {
  final String? iso3166_1;
  final String name;

  ProductionCountryModel({this.iso3166_1, required this.name});

  factory ProductionCountryModel.fromJson(Map<String, dynamic> json) {
    return ProductionCountryModel(
      iso3166_1: json['iso_3166_1'] as String?,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'iso_3166_1': iso3166_1, 'name': name};
}

class SpokenLanguageModel {
  final String? iso639_1;
  final String name;
  final String? englishName;

  SpokenLanguageModel({
    this.iso639_1,
    required this.name,
    this.englishName,
  });

  factory SpokenLanguageModel.fromJson(Map<String, dynamic> json) {
    return SpokenLanguageModel(
      iso639_1: json['iso_639_1'] as String?,
      name: json['name'] as String? ?? '',
      englishName: json['english_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'iso_639_1': iso639_1,
        'name': name,
        'english_name': englishName,
      };
}

class CreatorModel {
  final int id;
  final String name;
  final String? creditId;
  final int? gender;
  final String? profilePath;

  CreatorModel({
    required this.id,
    required this.name,
    this.creditId,
    this.gender,
    this.profilePath,
  });

  String get fullProfileUrl => profilePath != null && profilePath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w300$profilePath'
      : '';

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      creditId: json['credit_id'] as String?,
      gender: json['gender'] as int?,
      profilePath: json['profile_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'credit_id': creditId,
        'gender': gender,
        'profile_path': profilePath,
      };
}

class NetworkModel {
  final int id;
  final String name;
  final String? logoPath;
  final String? originCountry;

  NetworkModel({
    required this.id,
    required this.name,
    this.logoPath,
    this.originCountry,
  });

  String get fullLogoUrl => logoPath != null && logoPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w300$logoPath'
      : '';

  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logoPath: json['logo_path'] as String?,
      originCountry: json['origin_country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo_path': logoPath,
        'origin_country': originCountry,
      };
}

class SeasonModel {
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;
  final String? airDate;
  final double? voteAverage;

  SeasonModel({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
    this.airDate,
    this.voteAverage,
  });

  String get fullPosterUrl => posterPath != null && posterPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w500$posterPath'
      : '';

  String get airYear {
    if (airDate != null && airDate!.isNotEmpty) {
      return airDate!.split('-').first;
    }
    return '';
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      seasonNumber: json['season_number'] as int? ?? 0,
      episodeCount: json['episode_count'] as int? ?? 0,
      airDate: json['air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'season_number': seasonNumber,
        'episode_count': episodeCount,
        'air_date': airDate,
        'vote_average': voteAverage,
      };
}

class EpisodeModel {
  final int id;
  final String name;
  final String? overview;
  final String? airDate;
  final int? episodeNumber;
  final int? runtime;
  final int? seasonNumber;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;

  EpisodeModel({
    required this.id,
    required this.name,
    this.overview,
    this.airDate,
    this.episodeNumber,
    this.runtime,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  String get fullStillUrl => stillPath != null && stillPath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w500$stillPath'
      : '';

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String?,
      airDate: json['air_date'] as String?,
      episodeNumber: json['episode_number'] as int?,
      runtime: json['runtime'] as int?,
      seasonNumber: json['season_number'] as int?,
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'air_date': airDate,
        'episode_number': episodeNumber,
        'runtime': runtime,
        'season_number': seasonNumber,
        'still_path': stillPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };
}

class MediaDetailModel {
  final int id;
  final String mediaType; // 'movie' or 'tv'
  final String title;
  final String? originalTitle;
  final String? tagline;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String? lastAirDate;
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final String? status;
  final String? homepage;
  final bool? adult;
  final String? originalLanguage;
  final List<dynamic>? originCountry;
  final List<GenreModel> genres;
  final List<ProductionCompanyModel> productionCompanies;
  final List<ProductionCountryModel> productionCountries;
  final List<SpokenLanguageModel> spokenLanguages;

  // Movie specific
  final int? runtime;
  final int? budget;
  final int? revenue;

  // TV specific
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final List<dynamic>? episodeRunTime;
  final String? type;
  final List<CreatorModel> createdBy;
  final List<NetworkModel> networks;
  final List<SeasonModel> seasons;
  final EpisodeModel? lastEpisodeToAir;
  final EpisodeModel? nextEpisodeToAir;

  MediaDetailModel({
    required this.id,
    required this.mediaType,
    required this.title,
    this.originalTitle,
    this.tagline,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.lastAirDate,
    this.voteAverage,
    this.voteCount,
    this.popularity,
    this.status,
    this.homepage,
    this.adult,
    this.originalLanguage,
    this.originCountry,
    this.genres = const [],
    this.productionCompanies = const [],
    this.productionCountries = const [],
    this.spokenLanguages = const [],
    this.runtime,
    this.budget,
    this.revenue,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.episodeRunTime,
    this.type,
    this.createdBy = const [],
    this.networks = const [],
    this.seasons = const [],
    this.lastEpisodeToAir,
    this.nextEpisodeToAir,
  });

  bool get isMovie => mediaType == 'movie';
  bool get isTv => mediaType == 'tv';

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

  String get formattedRuntime {
    if (runtime != null && runtime! > 0) {
      final hours = runtime! ~/ 60;
      final minutes = runtime! % 60;
      if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
      if (hours > 0) return '${hours}h';
      return '${minutes}m';
    }
    return '';
  }

  String get seasonsAndEpisodesText {
    final s = numberOfSeasons ?? 0;
    final e = numberOfEpisodes ?? 0;
    if (s > 0 && e > 0) {
      return '$s ${s == 1 ? 'Season' : 'Seasons'} • $e ${e == 1 ? 'Episodes' : 'Episodes'}';
    } else if (s > 0) {
      return '$s ${s == 1 ? 'Season' : 'Seasons'}';
    } else if (e > 0) {
      return '$e ${e == 1 ? 'Episode' : 'Episodes'}';
    }
    return '';
  }

  String get formattedBudget => _formatCurrency(budget);
  String get formattedRevenue => _formatCurrency(revenue);

  static String _formatCurrency(int? amount) {
    if (amount == null || amount <= 0) return '-';
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return '\$$buffer';
  }

  factory MediaDetailModel.fromMovieJson(Map<String, dynamic> json) {
    return MediaDetailModel(
      id: json['id'] as int? ?? 0,
      mediaType: 'movie',
      title:
          json['title'] as String? ?? json['original_title'] as String? ?? '',
      originalTitle: json['original_title'] as String?,
      tagline: json['tagline'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      status: json['status'] as String?,
      homepage: json['homepage'] as String?,
      adult: json['adult'] as bool?,
      originalLanguage: json['original_language'] as String?,
      originCountry: json['origin_country'] as List<dynamic>?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) =>
                  ProductionCompanyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map((e) =>
                  ProductionCountryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) =>
                  SpokenLanguageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
    );
  }

  factory MediaDetailModel.fromTvJson(Map<String, dynamic> json) {
    return MediaDetailModel(
      id: json['id'] as int? ?? 0,
      mediaType: 'tv',
      title: json['name'] as String? ?? json['original_name'] as String? ?? '',
      originalTitle: json['original_name'] as String?,
      tagline: json['tagline'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['first_air_date'] as String?,
      lastAirDate: json['last_air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      status: json['status'] as String?,
      homepage: json['homepage'] as String?,
      adult: json['adult'] as bool?,
      originalLanguage: json['original_language'] as String?,
      originCountry: json['origin_country'] as List<dynamic>?,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) =>
                  ProductionCompanyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      productionCountries: (json['production_countries'] as List<dynamic>?)
              ?.map((e) =>
                  ProductionCountryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
              ?.map((e) =>
                  SpokenLanguageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      numberOfSeasons: json['number_of_seasons'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
      episodeRunTime: json['episode_run_time'] as List<dynamic>?,
      type: json['type'] as String?,
      createdBy: (json['created_by'] as List<dynamic>?)
              ?.map((e) => CreatorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      networks: (json['networks'] as List<dynamic>?)
              ?.map((e) => NetworkModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      seasons: (json['seasons'] as List<dynamic>?)
              ?.map((e) => SeasonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastEpisodeToAir: json['last_episode_to_air'] != null
          ? EpisodeModel.fromJson(
              json['last_episode_to_air'] as Map<String, dynamic>)
          : null,
      nextEpisodeToAir: json['next_episode_to_air'] != null
          ? EpisodeModel.fromJson(
              json['next_episode_to_air'] as Map<String, dynamic>)
          : null,
    );
  }
}
