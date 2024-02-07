import 'package:flutter/material.dart';
import 'package:flutter_ai_examples/app/app_settings/app_settings.dart';
import 'package:flutter_ai_examples/app/theme.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mistralAIApiKey = context.watch<AppSettings>().mistralApiKey;

    return DarkerBackgroundTheme(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App Settings'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Symbols.key_vertical),
                titleAlignment: ListTileTitleAlignment.titleHeight,
                title: const Text('Mistral AI API Key'),
                subtitle: Text('Current value: $mistralAIApiKey'),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => MistralAIApiKeyField(
                      currentApiKey: context.read<AppSettings>().mistralApiKey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MistralAIApiKeyField extends StatefulWidget {
  const MistralAIApiKeyField({
    required this.currentApiKey,
    super.key,
  });

  final String currentApiKey;

  @override
  State<MistralAIApiKeyField> createState() => _MistralAIApiKeyFieldState();
}

class _MistralAIApiKeyFieldState extends State<MistralAIApiKeyField> {
  late final TextEditingController inputController;

  @override
  void initState() {
    inputController = TextEditingController(text: widget.currentApiKey);
    super.initState();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _save(context),
          child: const Text('Update'),
        ),
      ],
      title: const Text('Update Mistral AI API Key'),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'API Key',
          border: OutlineInputBorder(),
        ),
        controller: inputController,
        autofocus: true,
        onSubmitted: (_) => _save(context),
      ),
    );
  }

  void _save(BuildContext context) {
    context.read<AppSettings>().mistralApiKey = inputController.text;
    Navigator.pop(context);
  }
}
