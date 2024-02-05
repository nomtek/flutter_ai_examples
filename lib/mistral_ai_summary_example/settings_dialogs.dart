import 'package:flutter/material.dart';
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
    return CommonSettingsDialog(
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
    return CommonSettingsDialog(
      title: 'Max Tokens',
      description: 'Write a number if you want to set a max of tokens',
      onSettingChanged: () {
        final maxTokens = _maxTokensController.text.isEmpty
            ? null
            : int.tryParse(_maxTokensController.text);
        context.read<SummarySettingsModel>().setMaxTokens(maxTokens);
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          const SizedBox(height: 24),
          TextField(
            controller: _maxTokensController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(_maxTokensController.clear),
                child: const Icon(Symbols.cancel),
              ),
              hintText: 'e.g. 500',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Unlimited',
              ),
              Switch(
                value: _maxTokensController.text.isEmpty,
                onChanged: null,
                activeTrackColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
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
    return CommonSettingsDialog(
      title: 'Random Seed',
      description: 'Write a number if you want to set a random seed',
      onSettingChanged: () {
        final randomSeed = _randomSeedController.text.isEmpty
            ? null
            : int.tryParse(_randomSeedController.text);
        context.read<SummarySettingsModel>().setRandomSeed(randomSeed);
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          const SizedBox(height: 24),
          TextField(
            controller: _randomSeedController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(_randomSeedController.clear),
                child: const Icon(Symbols.cancel),
              ),
              hintText: 'e.g. 123',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Unset',
              ),
              Switch(
                value: _randomSeedController.text.isEmpty,
                onChanged: null,
                activeTrackColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class CommonSettingsDialog extends StatelessWidget {
  const CommonSettingsDialog({
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
    return Dialog(
      child: SizedBox(
        width: 312,
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: onSettingChanged,
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
