import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';

String controllerDescription(ControllerSettings currentSettings) =>
    'You are a helpful assistant designed to output only JSON. '
    'You are given command and a set of functions that you can perform. '
    'Based on the command you should chose one of the provided functions '
    'If you do not understand the command, you should return a following JSON. '
    '{ "name": "unknown", "parameters": "" } '
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

  "turnOnTV" (parameters:bool)
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
  ###
  INPUT: "Turn on TV" 
  RESULT: { "name": "turnOnTV", "parameters": "true" }
  ###
  INPUT: "Turn off TV" 
  RESULT: { "name": "turnOnTV", "parameters": "false" }
  ''';
