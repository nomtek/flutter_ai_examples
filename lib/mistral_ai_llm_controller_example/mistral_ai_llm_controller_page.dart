import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/prompt.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/utils.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/mistral_client.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class MistralAiLlmControllerPage extends StatefulWidget {
  const MistralAiLlmControllerPage({super.key});

  @override
  State<MistralAiLlmControllerPage> createState() =>
      _MistralAiLlmControllerPageState();
}

class _MistralAiLlmControllerPageState
    extends State<MistralAiLlmControllerPage> {
  final TextEditingController commandInputController = TextEditingController();
  int volume = 50;
  int temperature = 20;
  bool showLoading = false;

  Future<String> sendCommand(String command) async {
    print('COMMAND: $command');
    try {
      setState(() => showLoading = true);
      final response = await mistralAIClient.chat(
        ChatParams(
          model: 'mistral-medium',
          messages: [
            ChatMessage(
              role: 'system',
              content: controllerDescription(
                Settings(
                  temperature: temperature,
                  volume: volume,
                ),
              ),
            ),
            const ChatMessage(role: 'system', content: controllerExample),
            ChatMessage(role: 'user', content: command),
          ],
        ),
      );
      setState(() => showLoading = false);
      print('Result: \n ${response.choices.last.message.content}');
      return response.choices.last.message.content;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  void mapCommandResponseToUi(String response) {
    final filteredResponse = extractJson(response);
    if (filteredResponse == null) {
      print('Invalid response: $response');
      return;
    }
    final json = jsonDecode(filteredResponse) as Map<String, dynamic>;
    final name = json['name'];
    final parameters = json['parameters'] as String?;
    if (name == null || parameters == null) {
      print('Invalid response: $response');
      return;
    }

    switch (name) {
      case 'setTemperature':
        setState(() => temperature = int.parse(parameters));
      case 'setVolume':
        setState(() => volume = int.parse(parameters));
      default:
        print('Unknown command: $name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MistralAI LLM Controller'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Color'),
                      subtitle: Container(
                        color: Colors.red,
                        height: 50,
                      ),
                    ),
                    ListTile(
                      title: Text('Volume: $volume '),
                      subtitle: Slider(
                        min: 0,
                        max: 100,
                        value: volume.toDouble(),
                        onChanged: (value) => setState(
                          () => volume = value.toInt(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Temperature (Celsius): $temperature'),
                      subtitle: Slider(
                        min: 15,
                        max: 25,
                        value: temperature.toDouble(),
                        onChanged: (value) => setState(
                          () => temperature = value.toInt(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: commandInputController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  suffixIcon: showLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final commandResult =
                                await sendCommand(commandInputController.text);
                            mapCommandResponseToUi(commandResult);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
