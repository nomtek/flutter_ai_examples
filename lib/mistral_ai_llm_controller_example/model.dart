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

sealed class ControllerFunction {
  const ControllerFunction({
    required this.name,
    required this.type,
    required this.example,
    this.additionalInfo = '',
  });

  factory ControllerFunction.fromName(String name) => switch (name) {
        SetTemperatureFunction.signature => const SetTemperatureFunction(),
        SetVolumeFunction.signature => const SetVolumeFunction(),
        SetColorOfLightFunction.signature => const SetColorOfLightFunction(),
        TurnOnTVFunction.signature => const TurnOnTVFunction(),
        _ => const UnknownFunction()
      };

  String get definition => '$name (parameters:$type) $additionalInfo'.trim();

  final String name;
  final String type;
  final String additionalInfo;
  final String example;
}

class SetTemperatureFunction extends ControllerFunction {
  const SetTemperatureFunction()
      : super(
          name: signature,
          type: 'temperature:number',
          example: '''
INPUT: "Set temperature to 17 degrees"
RESULT: { "name": "$signature", "parameters": "17" }
    ''',
        );
  static const String signature = 'setTemperature';
}

class SetVolumeFunction extends ControllerFunction {
  const SetVolumeFunction()
      : super(
          name: signature,
          type: 'volume:number',
          example: '''
INPUT: "Set volume to 10"
RESULT: { "name": "$signature", "parameters": "10" }
    ''',
        );
  static const String signature = 'setVolume';
}

class SetColorOfLightFunction extends ControllerFunction {
  const SetColorOfLightFunction()
      : super(
          name: signature,
          type: 'color:hex ',
          additionalInfo: 'returns color in hex format only (#RRGGBB)',
          example: '''
INPUT: "Set color of light to orange"
RESULT: { "name": "$signature", "parameters": "#FFA500" }
    ''',
        );
  static const String signature = 'setColorOfLight';
}

class TurnOnTVFunction extends ControllerFunction {
  const TurnOnTVFunction()
      : super(
          name: signature,
          type: 'bool',
          example: '''
INPUT: "Turn on TV"
RESULT: { "name": "$signature", "parameters": "true" }
    ''',
        );
  static const String signature = 'turnOnTV';
}

class UnknownFunction extends ControllerFunction {
  const UnknownFunction()
      : super(
          name: 'unknown',
          type: '',
          example: '',
        );
}

const List<ControllerFunction> availableFunctions = [
  SetTemperatureFunction(),
  SetVolumeFunction(),
  SetColorOfLightFunction(),
  TurnOnTVFunction(),
];
