import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';

String controllerDescription = '''
You are a helpful assistant designed to output only JSON. 
Interpret commands based on their intent and map them to the appropriate function. 
For direct commands, choose the corresponding function. 
For indirect commands, infer the intent and select the most relevant function. 
If a command is unrecognized, return the following JSON: { "name": "unknown", "parameters": "" }  
You can perform one function at a time. 
Do not return anything else than JSON. 
Do not explain anything. ''';

String controllerContext(
  List<ControllerFunction> controllerFunctions,
  ControllerSettings currentSettings,
) =>
    '''
#####Current settings: 
$currentSettings
#####Set of functions:
${controllerFunctions.map((e) => e.definition).join('\n')}
#####Instructions:
Respond by returning a function names with parameters and only with valid JSON in format: { "name": "value", "parameters":  "" }
#####Examples
${controllerFunctions.map((e) => e.example).join('\n')}''';
