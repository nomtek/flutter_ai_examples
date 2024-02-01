import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/mistral_client.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/model.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/summary_settings_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/utils.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class MistralAISummaryPage extends StatefulWidget {
  const MistralAISummaryPage({super.key});

  @override
  State<MistralAISummaryPage> createState() => _MistralAISummaryPageState();
}

class _MistralAISummaryPageState extends State<MistralAISummaryPage> {
  final TextEditingController summaryInputController = TextEditingController();

  String summaryResult = '';

  SummarySettings summarySettings = SummarySettings();

  @override
  void dispose() {
    summaryInputController.dispose();
    super.dispose();
  }

  Future<void> summarizeText(String text) async {
    setState(() {
      summaryResult = 'Loading...';
    });
    try {
      final response = await mistralAIClient.chat(
        ChatParams(
          model: 'mistral-small',
          temperature: summarySettings.temperature,
          topP: summarySettings.topP,
          randomSeed: summarySettings.randomSeed,
          maxTokens: summarySettings.maxTokens,
          safePrompt: summarySettings.safePrompt,
          messages: [
            ChatMessage(role: 'user', content: text),
          ],
        ),
      );
      setState(() {
        summaryResult = response.choices.first.message.content;
      });
    } catch (e) {
      setState(() {
        summaryResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MistralAI Summary'),
        actions: [
          IconButton(
            onPressed: () async {
              final newSettings = await Navigator.push(
                context,
                MaterialPageRoute<SummarySettings>(
                  builder: (BuildContext context) => SettingsWidget(
                    initialSettings: summarySettings,
                  ),
                ),
              );
              setState(() {
                summarySettings = newSettings ?? summarySettings;
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter text to summarize',
                ),
                minLines: 1,
                maxLines: 10,
                onChanged: (value) => summaryInputController.text = value,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      summarizeText(summaryInputController.text);
                    },
                    child: const Text('Summarize'),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          summarizeText(summaryTextSample);
                        },
                        child: const Text('Summarize sample tex'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (context) => const SampleTextDialogButton(),
                        ),
                        child: const Text('See sample text'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Summarized Text:'),
              const SizedBox(height: 10),
              SelectableText(summaryResult),
            ],
          ),
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
