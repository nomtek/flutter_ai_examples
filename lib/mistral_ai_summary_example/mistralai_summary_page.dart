import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_examples/mistral_ai_summary_example/settings_model.dart';
import 'package:flutter_ai_examples/mistral_ai_summary_example/summary_settings_page.dart';
import 'package:flutter_ai_examples/mistral_ai_summary_example/utils.dart';
import 'package:flutter_ai_examples/utils/error_message.dart';
import 'package:flutter_ai_examples/utils/snackbar_extension.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:provider/provider.dart';

class MistralAISummaryPage extends StatefulWidget {
  const MistralAISummaryPage({super.key});

  @override
  State<MistralAISummaryPage> createState() => _MistralAISummaryPageState();
}

class _MistralAISummaryPageState extends State<MistralAISummaryPage> {
  final TextEditingController summaryInputController = TextEditingController();

  String summaryResult = '';
  bool summaryInProgress = false;

  @override
  void dispose() {
    summaryInputController.dispose();
    super.dispose();
  }

  Future<void> summarizeText(
    BuildContext context,
    String text,
    SummarySettings settings,
  ) async {
    setState(() => summaryInProgress = true);
    try {
      final response = await context.read<MistralAIClient>().chat(
            ChatParams(
              model: 'mistral-medium',
              temperature: settings.temperature,
              topP: settings.topP,
              randomSeed: settings.randomSeed,
              maxTokens: settings.maxTokens,
              safePrompt: settings.safePrompt,
              messages: [
                ChatMessage(
                  role: 'user',
                  content: getSummaryPromptForText(text),
                ),
              ],
            ),
          );
      setState(() {
        summaryResult = response.choices.first.message.content;
      });
    } catch (e) {
      debugPrint('$e');
      if (!context.mounted) return;
      context.showMessageSnackBar(getNiceErrorMessage(e));
    } finally {
      setState(() => summaryInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SummarySettingsModel(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('MistralAI Text Summary'),
            actions: const [
              SummarySettingsButton(),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: <Widget>[
                  SummaryTextInput(
                    summaryInputController: summaryInputController,
                  ),
                  const SizedBox(height: 20),
                  SummaryActions(
                    onSummarize: () => summarizeText(
                      context,
                      summaryInputController.text,
                      context.read<SummarySettingsModel>().settings,
                    ),
                    summaryInputController: summaryInputController,
                  ),
                  const SizedBox(height: 20),
                  SummaryResultText(
                    summaryResult: summaryResult,
                    isLoading: summaryInProgress,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SummaryActions extends StatelessWidget {
  const SummaryActions({
    required this.onSummarize,
    required this.summaryInputController,
    super.key,
  });

  final VoidCallback onSummarize;
  final TextEditingController summaryInputController;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: onSummarize,
          child: const Text('Summarize'),
        ),
        const SizedBox(width: 16),
        SampleTextPasteButton(
          summaryInputController: summaryInputController,
        ),
      ],
    );
  }
}

class SummaryResultText extends StatelessWidget {
  const SummaryResultText({
    required this.summaryResult,
    required this.isLoading,
    super.key,
  });

  final String summaryResult;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (summaryResult.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Text(
          'Summary:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        SelectableText(summaryResult),
      ],
    );
  }
}

class SummaryTextInput extends StatelessWidget {
  const SummaryTextInput({
    required this.summaryInputController,
    super.key,
  });

  final TextEditingController summaryInputController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: summaryInputController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter text to summarize',
      ),
      minLines: 1,
      maxLines: 10,
      onChanged: (value) => summaryInputController.text = value,
    );
  }
}

class SampleTextPasteButton extends StatelessWidget {
  const SampleTextPasteButton({
    required this.summaryInputController,
    super.key,
  });

  final TextEditingController summaryInputController;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        summaryInputController.text = summaryTextSample;
      },
      child: Text(
        'Paste sample text',
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class SampleTextDialogButton extends StatelessWidget {
  const SampleTextDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: SelectableText(summaryTextSample),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: summaryTextSample),
                    );
                  },
                  child: const Text('Copy all'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummarySettingsButton extends StatelessWidget {
  const SummarySettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsModel = context.watch<SummarySettingsModel>();
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<SummarySettings>(
          builder: (_) => ChangeNotifierProvider.value(
            value: settingsModel,
            child: const SettingsWidget(),
          ),
        ),
      ),
      icon: const Icon(Icons.settings),
    );
  }
}
