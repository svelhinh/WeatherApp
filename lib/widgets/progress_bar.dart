import 'dart:async';

import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    super.key,
    this.onDone,
  });

  final Function? onDone;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  Timer? _progressBarMessagesTimer;
  final List<String> _progressBarMessages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Plus que quelques secondes avant d'avoir le résultat...",
  ];
  int _progressBarCurrentMessageIndex = 0;

  final Duration _progressBarDuration = const Duration(seconds: 60);
  final Duration _progressBarMessagesTimerDuration = const Duration(seconds: 3);

  // Lance le timer pour les messages de la barre de progression
  @override
  void initState() {
    _progressBarCurrentMessageIndex = 0;

    _controller =
        AnimationController(vsync: this, duration: _progressBarDuration)
          ..addListener(() {
            if (_controller.value >= 1) {
              _progressBarMessagesTimer?.cancel();
              if (widget.onDone != null) {
                widget.onDone!();
              }
            }
            setState(() {});
          });

    _controller.forward();

    _progressBarMessagesTimer =
        Timer.periodic(_progressBarMessagesTimerDuration, (timer) {
      setState(() {
        if (_progressBarCurrentMessageIndex >=
            _progressBarMessages.length - 1) {
          _progressBarCurrentMessageIndex = 0;
        } else {
          _progressBarCurrentMessageIndex++;
        }
      });
    });

    super.initState();
  }

  // Construit la barre de progression et retourne un widget représentant la barre de progression avec le message et le pourcentage de progression affichés
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(_progressBarMessages[_progressBarCurrentMessageIndex]),
          Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: _controller.value,
                  color: theme.colorScheme.inversePrimary,
                  backgroundColor: theme.colorScheme.primary,
                  minHeight: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "${(_controller.value * 100).floor()}%",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Libère les ressources utilisées par l'animation de la barre de progression et les messages
  @override
  void dispose() {
    _controller.dispose();
    _progressBarMessagesTimer?.cancel();

    super.dispose();
  }
}
