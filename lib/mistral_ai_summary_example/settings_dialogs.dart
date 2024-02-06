import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/settings_model.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late MistralAIModel selectedModel;

  @override
  void initState() {
    super.initState();
    selectedModel = context.read<SummarySettingsModel>().settings.model;
  }

  @override
  Widget build(BuildContext context) {
    return BaseSettingsDialog(
      title: 'Model',
      description: 'Choose a Mistral model',
      onSettingChanged: () {
        context.read<SummarySettingsModel>().setModel(selectedModel);
        Navigator.of(context).pop();
      },
      child: Column(
        children: MistralAIModel.values
            .map(
              (model) => RadioListTile<MistralAIModel>(
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                title: Text(
                  model.name,
                  maxLines: 1,
                ),
                value: model,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: selectedModel,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedModel = value);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class MaxTokensDialog extends StatefulWidget {
  const MaxTokensDialog({
    super.key,
  });

  @override
  State<MaxTokensDialog> createState() => _MaxTokensDialogState();
}

class _MaxTokensDialogState extends State<MaxTokensDialog> {
  final TextEditingController _maxTokensController = TextEditingController();

  @override
  void initState() {
    _maxTokensController.text =
        context.read<SummarySettingsModel>().settings.maxTokens?.toString() ??
            '';
    super.initState();
  }

  @override
  void dispose() {
    _maxTokensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNumberInputDialog(
      title: 'Max Tokens',
      description: 'Write a number if you want to set a max of tokens',
      hintText: 'e.g. 300',
      controller: _maxTokensController,
      onSettingChanged: (value) {
        context.read<SummarySettingsModel>().setMaxTokens(value);
        Navigator.of(context).pop();
      },
      onInputChanged: (value) => setState(() {}),
      onClear: () => setState(_maxTokensController.clear),
    );
  }
}

class RandomSeedDialog extends StatefulWidget {
  const RandomSeedDialog({
    super.key,
  });

  @override
  State<RandomSeedDialog> createState() => _RandomSeedDialogState();
}

class _RandomSeedDialogState extends State<RandomSeedDialog> {
  final TextEditingController _randomSeedController = TextEditingController();

  @override
  void initState() {
    _randomSeedController.text =
        context.read<SummarySettingsModel>().settings.randomSeed?.toString() ??
            '';
    super.initState();
  }

  @override
  void dispose() {
    _randomSeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseNumberInputDialog(
      title: 'Random Seed',
      description: 'Write a number if you want to set a random seed',
      hintText: 'e.g. 123',
      controller: _randomSeedController,
      onSettingChanged: (value) {
        context.read<SummarySettingsModel>().setRandomSeed(value);
        Navigator.of(context).pop();
      },
      onInputChanged: (value) => setState(() {}),
      onClear: () => setState(_randomSeedController.clear),
    );
  }
}

class BaseNumberInputDialog extends StatelessWidget {
  const BaseNumberInputDialog({
    required this.title,
    required this.description,
    required this.hintText,
    required this.controller,
    required this.onSettingChanged,
    required this.onInputChanged,
    required this.onClear,
    super.key,
  });

  final String title;
  final String description;
  final String hintText;
  final TextEditingController controller;
  final void Function(int?) onSettingChanged;
  final void Function(String?) onInputChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return BaseSettingsDialog(
      title: title,
      description: description,
      onSettingChanged: () {
        final value =
            controller.text.isEmpty ? null : int.tryParse(controller.text);
        onSettingChanged(value);
      },
      child: Column(
        children: [
          const SizedBox(height: 24),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: controller,
            onChanged: onInputChanged,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onClear,
                child: const Icon(Symbols.cancel),
              ),
              hintText: hintText,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class BaseSettingsDialog extends StatelessWidget {
  const BaseSettingsDialog({
    required this.title,
    required this.description,
    required this.child,
    required this.onSettingChanged,
    super.key,
  });

  final String title;
  final String description;
  final Widget child;
  final VoidCallback onSettingChanged;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Theme.of(context).colorScheme.surfaceVariant,
      content: SizedBox(
        width: 312, // 312 is the width of the dialog in the design
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              child,
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onSettingChanged,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
