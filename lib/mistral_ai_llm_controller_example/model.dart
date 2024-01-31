import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class ControllerResponse {
  const ControllerResponse({required this.name, required this.parameters});

  factory ControllerResponse.fromJson(Map<String, dynamic> json) =>
      _$ControllerResponseFromJson(json);

  final String name;
  final String parameters;

  Map<String, dynamic> toJson() => _$ControllerResponseToJson(this);
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
    return 'Settings { '
        'temperature: $temperature, volume: $volume, color: $color}, '
        'isTVOn: $isTVOn';
  }
}

class ControllerFunctions {
  static const String setTemperature = 'setTemperature';
  static const String setVolume = 'setVolume';
  static const String setColorOfLight = 'setColorOfLight';
  static const String turnOnTV = 'turnOnTV';
}

class ControllerFunction {
  const ControllerFunction({
    required this.definition,
    required this.example,
  });

  final String definition;
  final String example;
}

const List<ControllerFunction> controllerFunctions = [
  ControllerFunction(
    definition:
        '${ControllerFunctions.setTemperature} (parameters:temperature:number)',
    example: '''
INPUT: "Set temperature to 17 degrees"
RESULT: { "name": "${ControllerFunctions.setTemperature}", "parameters": "17" }
    ''',
  ),
  ControllerFunction(
    definition: '${ControllerFunctions.setVolume} (parameters:volume:number)',
    example: '''
INPUT: "Set volume to 10"
RESULT: { "name": "${ControllerFunctions.setVolume}", "parameters": "10" }
    ''',
  ),
  ControllerFunction(
    definition: '${ControllerFunctions.setColorOfLight} (parameters:color:hex) '
        'returns color in hex format only (#RRGGBB)',
    example: '''
INPUT: "Set color of light to orange" 
RESULT: { "name": "${ControllerFunctions.setColorOfLight}", "parameters": "#FFA500" }
    ''',
  ),
  ControllerFunction(
    definition: '${ControllerFunctions.turnOnTV} (parameters:bool)',
    example: '''
INPUT: "Turn on TV" 
RESULT: { "name": "${ControllerFunctions.turnOnTV}", "parameters": "true" }
    ''',
  ),
];
