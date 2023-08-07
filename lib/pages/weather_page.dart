import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/progress_bar.dart';

import '../services/weather_data.dart';
import '../services/weather_model.dart';

class WeatherPage extends StatefulWidget {
  static const routeName = "/weather";

  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Timer? _weatherTimer;
  final WeatherModel _weatherModel = WeatherModel();
  final List<Function> _weathers = [];
  int _currentWeatherIndex = 0;

  final List<WeatherData> _weatherData = [];

  bool _isDoneFetchingWeather = false;

  final Duration _weatherTimerDuration = const Duration(seconds: 10);

  // Initialise le contrôleur de l'animation de la barre de progression et la liste des fonctions pour récupérer la météo
  // Initialise le téléchargement des données météo en appelant _initAll()
  @override
  void initState() {
    _weathers.addAll([
      () => _weatherModel.getRennesWeather(),
      () => _weatherModel.getParisWeather(),
      () => _weatherModel.getNantesWeather(),
      () => _weatherModel.getBordeauxWeather(),
      () => _weatherModel.getLyonWeather(),
    ]);

    _initAll();

    super.initState();
  }

  // Retourne le widget Scaffold avec la barre d'applications et le corps affichant soit la barre de progression, soit la vue météo
  // Selon que le téléchargement des données est terminé ou non
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _isDoneFetchingWeather
              ? _buildWeatherView(theme)
              : ProgressBar(
                  onDone: () {
                    _isDoneFetchingWeather = true;
                    _weatherTimer?.cancel();

                    setState(() {});
                  },
                ),
        ),
      ),
    );
  }

  /// Initialise les variables et démarre le téléchargement des données météo
  /// Remet les compteurs et les listes à zéro, puis démarre les timers et les messages de la barre de progression
  void _initAll() {
    _currentWeatherIndex = 0;

    _weatherData.clear();

    _initTimers();

    _isDoneFetchingWeather = false;
  }

  /// Initialise les timers
  /// Récupère les données météo de la première ville et lance le timer pour récupérer les autres données météo
  void _initTimers() async {
    _weatherData.add(await _weathers[_currentWeatherIndex]());
    _currentWeatherIndex++;

    _weatherTimer = Timer.periodic(_weatherTimerDuration, (timer) async {
      _weatherData.add(await _weathers[_currentWeatherIndex]());

      _currentWeatherIndex++;

      if (_currentWeatherIndex >= _weathers.length) {
        _weatherTimer?.cancel();
      }
    });
  }

  /// Redémarre le téléchargement des données
  /// Appelle _initAll() pour réinitialiser les variables et démarre le téléchargement des données
  /// Met à jour l'interface graphique en appelant setState()
  void _restart() {
    _initAll();

    setState(() {});
  }

  /// Construit la vue météo
  /// Retourne un widget représentant la liste des données météo pour chaque ville, ainsi qu'un bouton pour recommencer le téléchargement
  Widget _buildWeatherView(ThemeData theme) {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                WeatherData weather = _weatherData[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: Text(weather.cityName)),
                        Expanded(child: Text("${weather.temp}°C")),
                        weather.clouds >= 50
                            ? const Icon(Icons.cloud)
                            : const Icon(Icons.cloud_outlined)
                      ],
                    ),
                  ),
                );
              },
              itemCount: _weatherData.length,
            ),
          ),
          ElevatedButton(
            onPressed: _restart,
            child: const Text("Recommencer"),
          ),
        ],
      ),
    );
  }

  // Annule le timer de la météo
  @override
  void dispose() {
    _weatherTimer?.cancel();
    super.dispose();
  }
}
