import 'package:flutter/material.dart';

class ControllerFunctions {
  static const String setTemperature = 'setTemperature';
  static const String setVolume = 'setVolume';
  static const String setColorOfLight = 'setColorOfLight';
  static const String turnOnTV = 'turnOnTV';
}

class ControllerSettings {
  ControllerSettings({
    this.temperature = 20.0,
    this.volume = 50,
    this.color = Colors.black,
    this.isTVOn = false,
  });

  double temperature;
  int volume;
  Color color;
  bool isTVOn = false;

  @override
  String toString() {
    return 'Settings{ '
        'temperature: $temperature, volume: $volume, color: $color} ';
  }
}
