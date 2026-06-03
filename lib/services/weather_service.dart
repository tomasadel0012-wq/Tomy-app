import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your API key from OpenWeatherMap

  /// Fetch current weather data by city name
  static Future<WeatherData> getCurrentWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  /// Fetch current weather data by coordinates (latitude, longitude)
  static Future<WeatherData> getCurrentWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  /// Fetch 5-day weather forecast by city name
  static Future<List<ForecastData>> get5DayForecastByCity(
    String cityName,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'];

        return forecastList
            .map((item) => ForecastData.fromJson(item))
            .toList();
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  /// Fetch 5-day weather forecast by coordinates
  static Future<List<ForecastData>> get5DayForecastByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> forecastList = data['list'];

        return forecastList
            .map((item) => ForecastData.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  /// Get weather icon URL
  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  /// Get weather icon based on weather condition
  static String getWeatherEmoji(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'thunderstorm':
        return '⛈️';
      case 'drizzle':
        return '🌧️';
      case 'rain':
        return '🌧️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'ash':
      case 'squall':
      case 'tornado':
        return '🌫️';
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      default:
        return '🌤️';
    }
  }
}
