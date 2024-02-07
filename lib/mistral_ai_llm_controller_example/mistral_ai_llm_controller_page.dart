import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/theme.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/logger_dialog.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/model.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/prompt.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/utils.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:provider/provider.dart';

class MistralAILlmControllerPage extends StatefulWidget {
  const MistralAILlmControllerPage({super.key});

  @override
  State<MistralAILlmControllerPage> createState() =>
      _MistralAiLlmControllerPageState();
}

class _MistralAiLlmControllerPageState
    extends State<MistralAILlmControllerPage> {
  final TextEditingController commandInputController = TextEditingController();
  ControllerSettings controllerSettings = ControllerSettings();
  bool showLoading = false;
  String errorMessage = '';
  String logger = '';

  @override
  void dispose() {
    commandInputController.dispose();
    super.dispose();
  }

  void _log(String message) {
    setState(() => logger += message);
  }

  void _clearLogAndError() {
    setState(() {
      logger = '';
      errorMessage = '';
    });
  }

  Future<String> _getResponseFromAI(
    BuildContext context,
    String command,
  ) async {
    setState(() {
      showLoading = true;
      _log(commandMessage(command, controllerSettings));
    });

    final response = await context.read<MistralAIClient>().chat(
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

    setState(() {
      showLoading = false;
      _log(responseMessage(response.choices.last.message.content));
    });

    return response.choices.last.message.content;
  }

  void _mapCommandResponseToUi(String response) {
    final filteredResponse = extractJson(response);
    if (filteredResponse == null) {
      setState(() => errorMessage = invalidResponseMessage(response));
      return;
    }
    final controllerResponse = ControllerResponse.fromJson(
      jsonDecode(filteredResponse) as Map<String, dynamic>,
    );

    final function = ControllerFunction.fromName(controllerResponse.name);

    switch (function) {
      case SetTemperatureFunction():
        setState(
          () => controllerSettings.temperature =
              double.parse(controllerResponse.parameters),
        );
      case SetVolumeFunction():
        setState(
          () => controllerSettings.volume =
              double.parse(controllerResponse.parameters).toInt(),
        );
      case SetColorOfLightFunction():
        final color = getColorFromHex(controllerResponse.parameters);
        setState(() => controllerSettings.color = color);
      case TurnOnTVFunction():
        setState(
          () => controllerSettings.isTVOn =
              bool.parse(controllerResponse.parameters),
        );
      default:
        setState(() => errorMessage = 'Unknown command');
    }
  }

  Future<void> _sendCommand(BuildContext context) async {
    setState(() {
      _clearLogAndError();
      showLoading = true;
    });
    try {
      final commandResult = await _getResponseFromAI(
        context,
        commandInputController.text,
      );
      _mapCommandResponseToUi(commandResult);
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkerBackgroundTheme(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MistralAI LLM Controller'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    LlmControllerColorOFLightTile(
                      controllerSettings: controllerSettings,
                    ),
                    const LlmControllerSpacer(),
                    LlmControllerVolumeTile(
                      controllerSettings: controllerSettings,
                    ),
                    const LlmControllerSpacer(),
                    LlmControllerTemperatureTile(
                      controllerSettings: controllerSettings,
                    ),
                    const LlmControllerSpacer(),
                    LlmControllerTVTile(controllerSettings: controllerSettings),
                    if (errorMessage.isNotEmpty)
                      Column(
                        children: [
                          const LlmControllerSpacer(),
                          LlmControllerErrorTile(errorMessage: errorMessage),
                        ],
                      ),
                  ],
                ),
              ),
              LlmControllerInputSection(
                onSendPressed: () => _sendCommand(context),
                showLoading: showLoading,
                commandInputController: commandInputController,
                logger: logger,
                errorMessage: errorMessage,
                controllerSettings: controllerSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LlmControllerColorOFLightTile extends StatelessWidget {
  const LlmControllerColorOFLightTile({
    required this.controllerSettings,
    super.key,
  });

  final ControllerSettings controllerSettings;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Color of light:'),
      subtitle: Container(
        decoration: BoxDecoration(
          color: controllerSettings.color,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 50,
      ),
    );
  }
}

class LlmControllerVolumeTile extends StatelessWidget {
  const LlmControllerVolumeTile({
    required this.controllerSettings,
    super.key,
  });

  final ControllerSettings controllerSettings;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Volume: ${controllerSettings.volume} '),
      subtitle: Slider(
        max: 100,
        value: controllerSettings.volume.toDouble(),
        onChanged: (_) {},
      ),
    );
  }
}

class LlmControllerTemperatureTile extends StatelessWidget {
  const LlmControllerTemperatureTile({
    required this.controllerSettings,
    super.key,
  });

  final ControllerSettings controllerSettings;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            value: controllerSettings.temperature,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

class LlmControllerTVTile extends StatelessWidget {
  const LlmControllerTVTile({
    required this.controllerSettings,
    super.key,
  });

  final ControllerSettings controllerSettings;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('TV'),
      trailing: Switch(
        value: controllerSettings.isTVOn,
        onChanged: (_) {},
      ),
    );
  }
}

class LlmControllerErrorTile extends StatelessWidget {
  const LlmControllerErrorTile({
    required this.errorMessage,
    super.key,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Error message: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class LlmControllerInputSection extends StatelessWidget {
  const LlmControllerInputSection({
    required this.onSendPressed,
    required this.showLoading,
    required this.commandInputController,
    required this.logger,
    required this.errorMessage,
    required this.controllerSettings,
    super.key,
  });

  final VoidCallback onSendPressed;
  final bool showLoading;
  final TextEditingController commandInputController;
  final String logger;
  final String errorMessage;
  final ControllerSettings controllerSettings;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => LoggerDialog(
                      logger: '$controllerDescription\n'
                          '${controllerContext(
                        availableFunctions,
                        controllerSettings,
                      )}',
                      errorMessage: '',
                    ),
                  ),
                  child: const Text('AI instruction'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => LoggerDialog(
                      logger: logger,
                      errorMessage: errorMessage,
                    ),
                  ),
                  child: const Text('Logger'),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                        onPressed: onSendPressed,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LlmControllerSpacer extends StatelessWidget {
  const LlmControllerSpacer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 24);
  }
}
