class ApiConfig {
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String tmdbToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZmUyZWQzMmE5ZTAyMWRiMDg3YzQxZjlhYzhlNWQ2ZiIsIm5iZiI6MTc5MDAyOTM1Ny40ODEsInN1YiI6IjZhYjFhZTJkMDEzNmU4Mzc1MGZiOTVhMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ytIlxpmLFsvpI9Tk8lSIXo5Eh-E-MWn94Tdaa2Ak6_s';

  static Map<String, String> get tmdbHeaders => {
        'Authorization': 'Bearer $tmdbToken',
        'accept': 'application/json',
      };
}
