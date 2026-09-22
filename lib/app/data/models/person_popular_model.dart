import 'package:screenly/config/api_config.dart';

class PersonPopularModel {
  final int id;
  final String name;
  final String? profilePath;
  final String? knownForDepartment;
  final double? popularity;
  final int? gender;
  final List<dynamic>? knownFor;

  PersonPopularModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.knownForDepartment,
    this.popularity,
    this.gender,
    this.knownFor,
  });

  String get fullProfileUrl => profilePath != null && profilePath!.isNotEmpty
      ? '${ApiConfig.tmdbImageBaseUrl}/w500$profilePath'
      : '';

  factory PersonPopularModel.fromJson(Map<String, dynamic> json) {
    return PersonPopularModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      gender: json['gender'] as int?,
      knownFor: json['known_for'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'known_for_department': knownForDepartment,
      'popularity': popularity,
      'gender': gender,
      'known_for': knownFor,
    };
  }
}

class PersonPopularResponseModel {
  final int page;
  final List<PersonPopularModel> results;
  final int? totalPages;
  final int? totalResults;

  PersonPopularResponseModel({
    required this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory PersonPopularResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonPopularResponseModel(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((item) =>
                  PersonPopularModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int?,
      totalResults: json['total_results'] as int?,
    );
  }
}

