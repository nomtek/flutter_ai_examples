import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/model.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    required this.title,
    required this.description,
    // required this.child,
    required this.onSettingChanged,
    super.key,
  });

  final String title;
  final String description;
  // final Widget child;
  final VoidCallback onSettingChanged;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  MistralAIModel selectedModel = MistralAIModel.mistralMedium;
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
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Column(
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
                          print(value);
                          if (value == null) return;
                          setState(() => selectedModel = value);
                        },
                      ),
                    )
                    .toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: widget.onSettingChanged,
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
