import 'package:screenly/config/api_config.dart';

class TmdbAccountModel {
  final int id;
  final String name;
  final String username;
  final bool includeAdult;
  final String? iso6391;
  final String? iso31661;
  final String? avatarPath;
  final String? gravatarHash;

  TmdbAccountModel({
    required this.id,
    required this.name,
    required this.username,
    this.includeAdult = false,
    this.iso6391,
    this.iso31661,
    this.avatarPath,
    this.gravatarHash,
  });

  String get displayName => name.isNotEmpty ? name : username;

  String get avatarUrl {
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      if (avatarPath!.startsWith('http')) {
        return avatarPath!;
      }
      return '${ApiConfig.tmdbImageBaseUrl}/w200$avatarPath';
    }
    if (gravatarHash != null && gravatarHash!.isNotEmpty) {
      return 'https://www.gravatar.com/avatar/$gravatarHash?s=200&d=mp';
    }
    return '';
  }

  factory TmdbAccountModel.fromJson(Map<String, dynamic> json) {
    String? avatar;
    String? gravatar;

    if (json['avatar'] is Map) {
      final avatarMap = json['avatar'] as Map;
      if (avatarMap['tmdb'] is Map &&
          avatarMap['tmdb']['avatar_path'] != null) {
        avatar = avatarMap['tmdb']['avatar_path'].toString();
      }
      if (avatarMap['gravatar'] is Map &&
          avatarMap['gravatar']['hash'] != null) {
        gravatar = avatarMap['gravatar']['hash'].toString();
      }
    } else {
      avatar = json['avatar_path'] as String?;
      gravatar = json['gravatar_hash'] as String?;
    }

    return TmdbAccountModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      includeAdult: json['include_adult'] as bool? ?? false,
      iso6391: json['iso_639_1'] as String?,
      iso31661: json['iso_3166_1'] as String?,
      avatarPath: avatar,
      gravatarHash: gravatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'include_adult': includeAdult,
      'iso_639_1': iso6391,
      'iso_3166_1': iso31661,
      'avatar_path': avatarPath,
      'gravatar_hash': gravatarHash,
    };
  }
}
