import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/model.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    required this.initialSettings,
    super.key,
  });

  final SummarySettings initialSettings;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  SummarySettings summarySettings = SummarySettings();

  final TextEditingController modelController = TextEditingController();
  final TextEditingController maxTokensController = TextEditingController();
  final TextEditingController randomSeedController = TextEditingController();

  @override
  void initState() {
    super.initState();

    summarySettings = widget.initialSettings;
  }

  @override
  void dispose() {
    modelController.dispose();
    maxTokensController.dispose();
    randomSeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // to long to put in one line
    final temperatureStringValue =
        summarySettings.temperature.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Model: ${summarySettings.model.name}'),
                    subtitle: DropdownButton<MistralAIModel>(
                      value: summarySettings.model,
                      onChanged: (MistralAIModel? newValue) {
                        if (newValue == null) {
                          return;
                        }
                        setState(() {
                          summarySettings.model = newValue;
                        });
                      },
                      items: MistralAIModel.values
                          .map<DropdownMenuItem<MistralAIModel>>(
                              (MistralAIModel model) {
                        return DropdownMenuItem<MistralAIModel>(
                          value: model,
                          child: Text(model.name),
                        );
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Temperature: $temperatureStringValue'),
                        const Text(
                          'We generally recommend altering '
                          'this or Top P but not both.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Slider(
                      value: summarySettings.temperature,
                      label: summarySettings.temperature.toStringAsFixed(2),
                      onChanged: (value) => setState(
                        () => summarySettings.temperature =
                            double.parse(value.toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Top P: ${summarySettings.topP.toStringAsFixed(2)}',
                        ),
                        const Text(
                          'We generally recommend altering '
                          'this or Temperature but not both.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Slider(
                      value: summarySettings.topP,
                      label: summarySettings.topP.toStringAsFixed(2),
                      onChanged: (value) => setState(
                        () => summarySettings.topP =
                            double.parse(value.toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Max tokens: '
                        '${summarySettings.maxTokens ?? 'unlimited'}'),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(
                        () => summarySettings.maxTokens = int.tryParse(value),
                      ),
                      controller: maxTokensController,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Safe prompt: ${summarySettings.safePrompt}',
                    ),
                    trailing: Switch(
                      value: summarySettings.safePrompt,
                      onChanged: (value) =>
                          setState(() => summarySettings.safePrompt = value),
                    ),
                  ),
                  ListTile(
                    title: Text('Random seed: '
                        '${summarySettings.randomSeed ?? 'none'}'),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(
                        () => summarySettings.randomSeed = int.tryParse(value),
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
                    Navigator.pop(context, summarySettings);
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
