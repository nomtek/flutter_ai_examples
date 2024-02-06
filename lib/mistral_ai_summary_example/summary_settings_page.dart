import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/theme.dart';

import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/settings_dialogs.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/settings_model.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DarkerBackgroundTheme(
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ModelSettingWidget(),
                  SettingsListSpacer(),
                  TemperatureAndTopPSettingWidget(),
                  SettingsListSpacer(),
                  MaxTokensSettingWidget(),
                  SettingsListSpacer(),
                  RandomSeedSettingWidget(),
                  SettingsListSpacer(),
                  SafePromptSettingWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModelSettingWidget extends StatefulWidget {
  const ModelSettingWidget({
    super.key,
  });

  @override
  State<ModelSettingWidget> createState() => _ModelSettingWidgetState();
}

class _ModelSettingWidgetState extends State<ModelSettingWidget> {
  MistralAIModel selectedModel = MistralAIModel.mistralMedium;

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Model',
      settingValue: context.watch<SummarySettingsModel>().settings.model.name,
      onTap: () {
        final summarySettingsModel = context.read<SummarySettingsModel>();
        showDialog<void>(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: summarySettingsModel,
            child: const SettingsDialog(),
          ),
        );
      },
    );
  }
}

class TemperatureAndTopPSettingWidget extends StatelessWidget {
  const TemperatureAndTopPSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final temperature =
        context.watch<SummarySettingsModel>().settings.temperature;

    // to long to put in one line
    final temperatureStringValue = temperature.toStringAsFixed(2);

    final topP = context.watch<SummarySettingsModel>().settings.topP;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
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
                  onChanged: (value) => context
                      .read<SummarySettingsModel>()
                      .setTemperature(value),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top P: ${topP.toStringAsFixed(2)}',
                ),
                Slider(
                  value: topP,
                  label: topP.toStringAsFixed(2),
                  onChanged: (value) =>
                      context.read<SummarySettingsModel>().setTopP(value),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Max tokens',
      settingValue: context
              .watch<SummarySettingsModel>()
              .settings
              .maxTokens
              ?.toString() ??
          'Unlimited',
      onTap: () {
        final summarySettingsModel = context.read<SummarySettingsModel>();
        showDialog<void>(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: summarySettingsModel,
            child: const MaxTokensDialog(),
          ),
        );
      },
    );
  }
}

class RandomSeedSettingWidget extends StatelessWidget {
  const RandomSeedSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClickableSettingsItem(
      settingName: 'Random seed',
      settingValue: context
              .watch<SummarySettingsModel>()
              .settings
              .randomSeed
              ?.toString() ??
          'Unset',
      onTap: () {
        final summarySettingsModel = context.read<SummarySettingsModel>();
        showDialog<void>(
          context: context,
          builder: (_) => ChangeNotifierProvider.value(
            value: summarySettingsModel,
            child: const RandomSeedDialog(),
          ),
        );
      },
    );
  }
}

class SafePromptSettingWidget extends StatelessWidget {
  const SafePromptSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingValue =
        context.watch<SummarySettingsModel>().settings.safePrompt;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 29,
          vertical: 10,
        ),
        title: Text('Safe prompt: $settingValue '),
        value: settingValue,
        onChanged: (value) {
          context.read<SummarySettingsModel>().setSafePrompt(safePrompt: value);
        },
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
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 29,
          vertical: 8,
        ),
        title: Text(settingName),
        subtitle: Text(settingValue),
        onTap: onTap,
      ),
    );
  }
}
