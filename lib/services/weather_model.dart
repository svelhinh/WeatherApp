import 'location.dart';
import 'network_data.dart';
import 'weather_data.dart';

const weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather';
const String apiKey = 'ff07b2cec9f26c467f197276f86562eb';

class WeatherModel {
  /// Récupère la météo d'une localisation
  Future<dynamic> getLocationWeather(Location location) async {
    NetworkData networkHelper = NetworkData(
        '$weatherApiUrl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  /// Récupère la météo de Rennes
  Future<WeatherData> getRennesWeather() async {
    var weather =
        await getLocationWeather(Location(latitude: 48.11, longitude: -1.67));

    return getWeatherData("Rennes", weather);
  }

  /// Récupère la météo de Paris
  Future<dynamic> getParisWeather() async {
    var weather =
        await getLocationWeather(Location(latitude: 48.86, longitude: 2.33));

    return getWeatherData("Paris", weather);
  }

  /// Récupère la météo de Nantes
  Future<dynamic> getNantesWeather() async {
    var weather =
        await getLocationWeather(Location(latitude: 47.21, longitude: -1.55));

    return getWeatherData("Nantes", weather);
  }

  /// Récupère la météo de Bordeaux
  Future<dynamic> getBordeauxWeather() async {
    var weather =
        await getLocationWeather(Location(latitude: 44.83, longitude: -0.57));

    return getWeatherData("Bordeaux", weather);
  }

  /// Récupère la météo de Lyon
  Future<dynamic> getLyonWeather() async {
    var weather =
        await getLocationWeather(Location(latitude: 45.76, longitude: 4.83));

    return getWeatherData("Lyon", weather);
  }

  /// Formatte les infos météo
  WeatherData getWeatherData(String cityName, var weather) {
    if (weather == null) {
      return WeatherData(cityName: cityName, temp: 0, clouds: 0);
    }
    return WeatherData(
      cityName: cityName,
      temp: weather["main"]["temp"],
      clouds: weather["clouds"]["all"],
    );
  }
}
