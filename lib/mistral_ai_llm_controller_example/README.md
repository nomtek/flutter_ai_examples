# LLM as a controller example

This example showcase how to use [mistral_ai_client_dart](https://pub.dev/packages/mistralai_client_dart) to control the app.

The "LLM as a Controller" example showcases a practical implementation of using Large Language Models (LLMs) to control various aspects of a mobile application. This innovative approach utilizes the capabilities of LLMs to interpret user commands, process natural language inputs, and execute actions within the app. This particular example focuses on simulating smart home behavior.

Features:

- set color of light using text instruction
- set volume level using text instruction
- set temperature using text instruction
- turn on/off TV using text instruction

## Demo

gif or mp4, TBD after UI/UX

## Prompt and AI chat construction

The data sent to the LLM is divided into three messages.

- System message with general controller description
- System message with specific controller context (available functions, current state)
- User message with instruction for controller

```dart
  final response = await mistralAIClient.chat(
      ChatParams(
        model: 'mistral-medium',
        messages: [
          ChatMessage(role: 'system', content: controllerDescription),
          ChatMessage(
            role: 'system',
            content: controllerContext(
              availableFunctions,
              controllerSettings,
            ),
          ),
          ChatMessage(role: 'user', content: command),
        ],
      ),
    );

```

### Controller description

It defines the general purpose of the controller. It says what the controller can do and what it should return.

```text
You are a helpful assistant designed to output only JSON. 
Interpret commands based on their intent and map them to the appropriate function. 
For direct commands, choose the corresponding function. 
For indirect commands, infer the intent and select the most relevant function. 
If a command is unrecognized, return the following JSON: { "name": "unknown", "parameters": "" }  
You can perform one function at a time. 
Do not return anything else than JSON. 
Do not explain anything. 
```

Let's break it down:

```text
You are a helpful assistant designed to output only JSON.
```

This is used to tell AI chatbot that we are looking for JSON output.

```text
Interpret commands based on their intent and map them to the appropriate function.
```

This is used to tell AI chatbot his general purpose

```text
For direct commands, choose the corresponding function.
For indirect commands, infer the intent and select the most relevant function.
If a command is unrecognized, return the following JSON: { "name": "unknown", "parameters": "" }  
```

This is used to tell AI chatbot how to interpret commands and what to do if command is not recognized.

```text
You can perform one function at a time.
```

This is used to tell AI chatbot that we are looking for one function at a time.

```text
Do not return anything else than JSON.
Do not explain anything.
```

This is used to tell AI chatbot that we are looking for JSON output and that we are not looking for any explanations. Based on our experience, sometimes AI chatbot is trying to explain the answer instead of giving the answer.

### Controller context

It defines the current state of the controller, contains the available functions and examples of commands anr expected responses.

```text
#####Current settings: 
Settings { temperature: 20.0, volume: 50, color: Color(0xff000000)}, isTVOn: false
#####Set of functions:
setTemperature (parameters:temperature:number)
setVolume (parameters:volume:number)
setColorOfLight (parameters:color:hex ) returns color in hex format only (#RRGGBB)
turnOnTV (parameters:bool)
#####Instructions:
Respond by returning a function names with parameters and only with valid JSON in format: { "name": "value", "parameters":  "" }
#####Examples
INPUT: "Set temperature to 17 degrees"
RESULT: { "name": "setTemperature", "parameters": "17" }
    
INPUT: "Set volume to 10"
RESULT: { "name": "setVolume", "parameters": "10" }
    
INPUT: "Set color of light to orange"
RESULT: { "name": "setColorOfLight", "parameters": "#FFA500" }
    
INPUT: "Turn on TV"
RESULT: { "name": "turnOnTV", "parameters": "true" }
```

## Problems and difficulties  

An LLM does very well for direct commands, but it has problems with indirect commands. For example, if we ask the LLM to "turn on the TV", it will do what we expect, but when we tell the LLM "I am bored, play something", it will not know that turning on the TV might help.
