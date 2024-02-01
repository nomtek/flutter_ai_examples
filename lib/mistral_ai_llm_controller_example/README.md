## LLM as a controller example

The "LLM as a Controller" example showcases a practical implementation of using Large Language Models (LLMs) to control various aspects of a mobile application. This innovative approach utilizes the capabilities of LLMs to interpret user commands, process natural language inputs, and execute actions within the app. This particular example focuses on simulating smart home behavior.

### Demo

gif or mp4, TBD after UI/UX

### Prompt and AI chat construction

The data sent to the LLM is divided into three messages.

- System message with general controller description
- System message with specific controller context
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

#### Controller description

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

#### Controller context

### Problems and difficulties  
