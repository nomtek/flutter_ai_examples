import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/summary_settings.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    required this.initialSettings,
    required this.mistralAIClient,
    super.key,
  });

  final SummarySettings initialSettings;
  final MistralAIClient mistralAIClient;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  String model = 'mistral-small';
  double temperature = 0.7;
  double topP = 1;
  int? maxTokens;
  bool safePrompt = false;
  int? randomSeed;

  final TextEditingController modelController = TextEditingController();
  final TextEditingController maxTokensController = TextEditingController();
  final TextEditingController randomSeedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    temperature = widget.initialSettings.temperature;
    topP = widget.initialSettings.topP;
    maxTokens = widget.initialSettings.maxTokens;
    safePrompt = widget.initialSettings.safePrompt;
    randomSeed = widget.initialSettings.randomSeed;
    maxTokensController.text = maxTokens?.toString() ?? '';
    randomSeedController.text = randomSeed?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text('Model: $model'),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (context) => SeeAvailableModelsDialog(
                              mistralAIClient: widget.mistralAIClient,
                            ),
                          ),
                          child: const Text('See available models'),
                        ),
                      ],
                    ),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() => model = value),
                      controller: modelController,
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Temperature: ${temperature.toStringAsFixed(2)}'),
                    subtitle: Slider(
                      value: temperature,
                      label: temperature.toStringAsFixed(2),
                      onChanged: (value) => setState(
                        () => temperature =
                            double.parse(value.toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Top P: ${topP.toStringAsFixed(2)}'),
                    subtitle: Slider(
                      value: topP,
                      label: topP.toStringAsFixed(2),
                      onChanged: (value) => setState(
                        () => topP = double.parse(value.toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Max tokens: ${maxTokens ?? 'unlimited'}'),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(
                        () => maxTokens = int.tryParse(value),
                      ),
                      controller: maxTokensController,
                    ),
                  ),
                  ListTile(
                    title:
                        Text("Safe prompt: ${safePrompt ? 'true' : 'false'}"),
                    trailing: Switch(
                      value: safePrompt,
                      onChanged: (value) => setState(() => safePrompt = value),
                    ),
                  ),
                  ListTile(
                    title: Text('Random seed: $randomSeed'),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(
                        () => randomSeed = int.tryParse(value),
                      ),
                      controller: randomSeedController,
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      SummarySettings(
                        temperature: temperature,
                        topP: topP,
                        maxTokens: maxTokens,
                        safePrompt: safePrompt,
                        randomSeed: randomSeed,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SeeAvailableModelsDialog extends StatelessWidget {
  const SeeAvailableModelsDialog({required this.mistralAIClient, super.key});

  final MistralAIClient mistralAIClient;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            FutureBuilder(
              future: mistralAIClient.listModels(),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.data.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: SelectableText(
                          snapshot.data?.data[index].id ?? '',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
