import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class ControllerResponse {
  ControllerResponse({required this.name, required this.parameters});

  factory ControllerResponse.fromJson(Map<String, dynamic> json) =>
      _$ControllerResponseFromJson(json);

  final String name;
  final String parameters;

  Map<String, dynamic> toJson() => _$ControllerResponseToJson(this);
}

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
