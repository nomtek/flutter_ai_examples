import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/prompt.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/utils.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/mistral_client.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

// TODO(mgruchala): Hide logger in dialog.

class MistralAiLlmControllerPage extends StatefulWidget {
  const MistralAiLlmControllerPage({super.key});

  @override
  State<MistralAiLlmControllerPage> createState() =>
      _MistralAiLlmControllerPageState();
}

class _MistralAiLlmControllerPageState
    extends State<MistralAiLlmControllerPage> {
  final TextEditingController commandInputController = TextEditingController();
  ControllerSettings controllerSettings = ControllerSettings();
  bool showLoading = false;
  String errorMessage = '';
  String logger = '';

  Future<String> sendCommand(String command) async {
    setState(() {
      showLoading = true;
      logger += '\nCURRENT SETTINGS: $controllerSettings COMMAND: $command';
    });

    try {
      final response = await mistralAIClient.chat(
        ChatParams(
          model: 'mistral-medium',
          messages: [
            ChatMessage(
              role: 'system',
              content: controllerDescription(
                controllerSettings,
              ),
            ),
            const ChatMessage(role: 'system', content: controllerExample),
            ChatMessage(role: 'user', content: command),
          ],
        ),
      );

      setState(() {
        showLoading = false;
        logger += '\nRESPONSE: ${response.choices.last.message.content}';
      });

      return response.choices.last.message.content;
    } catch (e) {
      setState(() => errorMessage = e.toString());
      return Future.error(e);
    }
  }

  void mapCommandResponseToUi(String response) {
    final filteredResponse = extractJson(response);
    if (filteredResponse == null) {
      setState(() => errorMessage = 'Invalid response: $response');
      return;
    }
    final json = jsonDecode(filteredResponse) as Map<String, dynamic>;
    final name = json['name'];
    final parameters = json['parameters'] as String?;
    if (name == null || parameters == null) {
      setState(() => errorMessage = 'Invalid response: $response');
      return;
    }

    switch (name) {
      case 'setTemperature':
        setState(
          () => controllerSettings.temperature = double.parse(parameters),
        );
      case 'setVolume':
        setState(() => controllerSettings.volume = int.parse(parameters));
      case 'setColorOfLight':
        final color = getColorFromHex(parameters);
        setState(() => controllerSettings.color = color);
      default:
        setState(() => errorMessage = 'Unknown command: $name');
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
                      title: const Text('Color of light:'),
                      subtitle: Container(
                        color: controllerSettings.color,
                        height: 50,
                      ),
                    ),
                    ListTile(
                      title: Text('Volume: ${controllerSettings.volume} '),
                      subtitle: Slider(
                        max: 100,
                        value: controllerSettings.volume.toDouble(),
                        onChanged: (_) {},
                      ),
                    ),
                    ListTile(
                      title: Text('Temperature (Celsius): '
                          '${controllerSettings.temperature}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Range: 15 - 25',
                            textAlign: TextAlign.start,
                          ),
                          Slider(
                            min: 15,
                            max: 25,
                            value: controllerSettings.temperature.toDouble(),
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ),
                    if (logger.isNotEmpty)
                      ListTile(
                        title: Text(
                          'Logger: $logger',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    if (errorMessage.isNotEmpty)
                      ListTile(
                        title: Text(
                          'Error message: $errorMessage',
                          style: const TextStyle(color: Colors.red),
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
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            setState(() {
                              errorMessage = '';
                              logger = '';
                            });
                            try {
                              final commandResult = await sendCommand(
                                commandInputController.text,
                              );
                              mapCommandResponseToUi(commandResult);
                            } catch (e) {
                              setState(() => errorMessage = e.toString());
                            }
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
