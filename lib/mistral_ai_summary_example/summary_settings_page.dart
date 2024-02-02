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

    summarySettings
      ..maxTokens = widget.initialSettings.maxTokens
      ..model = widget.initialSettings.model
      ..randomSeed = widget.initialSettings.randomSeed
      ..safePrompt = widget.initialSettings.safePrompt
      ..temperature = widget.initialSettings.temperature
      ..topP = widget.initialSettings.topP;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ModelSettingWidget(summarySettings: summarySettings),
                const SettingsListSpacer(),
                TemperatureAndTopPSettingWidget(
                  temperature: summarySettings.temperature,
                  topP: summarySettings.topP,
                  onTemperatureChanged: (value) =>
                      setState(() => summarySettings.temperature = value),
                  onTopPChanged: (value) =>
                      setState(() => summarySettings.topP = value),
                ),
                const SettingsListSpacer(),
                MaxTokensSettingWidget(summarySettings: summarySettings),
                const SettingsListSpacer(),
                RandomSeedSettingWidget(summarySettings: summarySettings),
                const SettingsListSpacer(),
                SafePromptSettingWidget(
                  settingValue: summarySettings.safePrompt,
                  onChanged: (value) =>
                      setState(() => summarySettings.safePrompt = value),
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
    );
  }
}

class ModelSettingWidget extends StatelessWidget {
  const ModelSettingWidget({
    required this.summarySettings,
    super.key,
  });

  final SummarySettings summarySettings;

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Model',
      settingValue: summarySettings.model.name,
      onTap: () {},
    );
  }
}

class TemperatureAndTopPSettingWidget extends StatelessWidget {
  const TemperatureAndTopPSettingWidget({
    required this.temperature,
    required this.topP,
    required this.onTemperatureChanged,
    required this.onTopPChanged,
    super.key,
  });
  final double temperature;
  final double topP;
  final void Function(double) onTemperatureChanged;
  final void Function(double) onTopPChanged;

  @override
  Widget build(BuildContext context) {
    // to long to put in one line
    final temperatureStringValue = temperature.toStringAsFixed(2);

    return ColoredBox(
      color: Theme.of(context).highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature: $temperatureStringValue',
                ),
                Slider(
                  value: temperature,
                  label: temperature.toStringAsFixed(2),
                  onChanged: onTemperatureChanged,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top P: $topP',
                ),
                Slider(
                  value: topP,
                  label: topP.toStringAsFixed(2),
                  onChanged: onTopPChanged,
                ),
              ],
            ),
            const Text(
              'We recommend altering only one, not both',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaxTokensSettingWidget extends StatelessWidget {
  const MaxTokensSettingWidget({
    required this.summarySettings,
    super.key,
  });

  final SummarySettings summarySettings;

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Max tokens',
      settingValue: summarySettings.maxTokens.toString(),
      onTap: () {},
    );
  }
}

class RandomSeedSettingWidget extends StatelessWidget {
  const RandomSeedSettingWidget({
    required this.summarySettings,
    super.key,
  });

  final SummarySettings summarySettings;

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Random seed',
      settingValue: summarySettings.randomSeed.toString(),
      onTap: () {},
    );
  }
}

class SafePromptSettingWidget extends StatelessWidget {
  const SafePromptSettingWidget({
    required this.settingValue,
    required this.onChanged,
    super.key,
  });

  final bool settingValue;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safe prompt: $settingValue',
            ),
            Switch(
              value: settingValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsListSpacer extends StatelessWidget {
  const SettingsListSpacer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 24);
  }
}

class ClickableSettingsItem extends StatelessWidget {
  const ClickableSettingsItem({
    required this.settingName,
    required this.settingValue,
    required this.onTap,
    super.key,
  });

  final String settingName;
  final String settingValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        color: Theme.of(context).highlightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settingName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                settingValue,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
