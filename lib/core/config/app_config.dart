/// [AppConfig] stores global configuration settings for the application.
/// 
/// This class provides a centralized location for feature flags and 
/// environment-specific constants.
class AppConfig {
  /// Toggle between Mock Data and Live API.
  /// Set to [true] to fetch real data from TMDB.
  /// Set to [false] to use local hardcoded mock data.
  static const bool useLiveAPI = false;

  /// Your TMDB (The Movie Database) API Key.
  /// Obtain one from: https://www.themoviedb.org/settings/api
  static const String tmdbApiKey = "YOUR_API_KEY_HERE";

  /// Base URL for the TMDB API v3.
  static const String baseUrl = "https://api.themoviedb.org/3";

  /// Base URL for images from TMDB.
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
}

