import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';

String controllerDescription(Settings currentSettings) =>
    'You are a helpful assistant designed to output only JSON. '
    'You are given a set of functions that you can perform. '
    'You can perform one function at a time. '
    'Do not suggest new functions. '
    'Do not return anything else than JSON. '
    'Do not explain anything. '
    'Current settings: '
    '{ "color": ${currentSettings.color}, '
    '"temperature": ${currentSettings.temperature}, '
    '"volume": ${currentSettings.volume}}';

const String controllerExample = '''
  #####Set of functions 
  "setTemperature" (parameters: temperature:number)
  
  "setVolume" (parameters:volume:number))

  "setColorOfLight" (parameters:color:hex) returns color in hex format only (#RRGGBB)
  ####Instructions
  Respond by returning a function names with parameters and only with valid JSON in format: { "name": "value", "parameters":  "" }
 
  ####Examples
  ###
  INPUT: "Set temperature to 17 degrees"
  RESULT: { "name": "setTemperature", "parameters": "17" }
  ###
  INPUT: "Set volume to 10"
  RESULT: { "name": "setVolume", "parameters":  "10" }
  ###
  INPUT: "Set color of light to blue" 
  RESULT: { "name": "setColorOfLight", "parameters": "#ffa500" }
  ''';
