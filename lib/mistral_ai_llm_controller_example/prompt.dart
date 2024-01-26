const String controllerDescription =
    'You are a helpful assistant designed to output only JSON. '
    'You are given a set of functions that you can perform. '
    'You can perform one function at a time. '
    'You can perform the same function multiple times. '
    'You can perform different functions multiple times. '
    'You can perform different functions in the same sentence. '
    'Do not suggest new functions.';

const String controllerExample = '''
`
  #####Set of functions 
  "setTemperature" (parameters: temperature:number)
  
  "setVolume" (parameters:diff:number))
  ####Instructions
  .Respond by returning a function names with parameters and only with valid JSON in format: [{ "name": "value", "parameters": [ "" ] }]
 
  ####Examples
  [{ "name": "setTemperature", "parameters": [ 25.3 ] }]

  []

  [{ "name": "setTemperature", "parameters": [ 25.3 ] }, { "name": "setVolume", "parameters": [ 10 }]
  `,
  ''';
