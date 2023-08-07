import 'package:flutter/material.dart';

import 'weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Affiche un texte et un bouton, lorsqu'on clique sur le bouton, on est renvoyé vers la page météo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Cliquez sur le bouton ci-dessous pour avoir la météo',
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(WeatherPage.routeName),
              child: const Text("Cliquez ici !"),
            ),
          ],
        ),
      ),
    );
  }
}
