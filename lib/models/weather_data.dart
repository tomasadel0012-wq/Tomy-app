class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double visibility;
  final int cloudiness;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? 'Unknown',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      weatherMain: json['weather'][0]['main'] ?? 'Unknown',
      weatherDescription: json['weather'][0]['description'] ?? 'Unknown',
      weatherIcon: json['weather'][0]['icon'] ?? '01d',
      visibility: ((json['visibility'] ?? 0) / 1000).toDouble(),
      cloudiness: json['clouds']['all'] ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunrise'] ?? 0) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunset'] ?? 0) * 1000,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'country': country,
    'temperature': temperature,
    'feelsLike': feelsLike,
    'humidity': humidity,
    'pressure': pressure,
    'windSpeed': windSpeed,
    'weatherMain': weatherMain,
    'weatherDescription': weatherDescription,
    'weatherIcon': weatherIcon,
    'visibility': visibility,
    'cloudiness': cloudiness,
    'sunrise': sunrise.toIso8601String(),
    'sunset': sunset.toIso8601String(),
  };
}

class ForecastData {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final int cloudiness;
  final double rainChance;

  ForecastData({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.cloudiness,
    required this.rainChance,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      dateTime: DateTime.parse(json['dt_txt']),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      weatherMain: json['weather'][0]['main'] ?? 'Unknown',
      weatherDescription: json['weather'][0]['description'] ?? 'Unknown',
      weatherIcon: json['weather'][0]['icon'] ?? '01d',
      cloudiness: json['clouds']['all'] ?? 0,
      rainChance: ((json['pop'] ?? 0) * 100).toDouble(),
    );
  }
}
