import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';

String controllerDescription(Settings currentSettings) =>
    'You are a helpful assistant designed to output only JSON. '
    'You are given a set of functions that you can perform. '
    'You can perform one function at a time. '
    'Do not suggest new functions. '
    'Current settings: '
    '{"temperature": ${currentSettings.temperature}, '
    '"volume": ${currentSettings.volume}}';

const String controllerExample = '''
  #####Set of functions 
  "setTemperature" (parameters: temperature:number)
  
  "setVolume" (parameters:diff:number))
  ####Instructions
  Respond by returning a function names with parameters and only with valid JSON in format: { "name": "value", "parameters":  "" }
 
  ####Examples
  { "name": "setTemperature", "parameters": "25.3" }

  { "name": "setVolume", "parameters":  "10" }
  ''';
