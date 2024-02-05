import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/model.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  MistralAIModel selectedModel = MistralAIModel.mistralMedium;
  @override
  Widget build(BuildContext context) {
    return CommonSettingsDialog(
      title: 'Model',
      description: 'Choose a Mistral model',
      onSettingChanged: () {},
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
  void dispose() {
    _maxTokensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonSettingsDialog(
      title: 'Max Tokens',
      description: 'Write a number if you want to set a max of tokens',
      onSettingChanged: () {},
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
                onChanged: (value) {},
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
