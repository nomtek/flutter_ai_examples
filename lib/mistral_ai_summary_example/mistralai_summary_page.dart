import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/utils.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class MistralAISummaryPage extends StatefulWidget {
  const MistralAISummaryPage({super.key});

  @override
  State<MistralAISummaryPage> createState() => _MistralAISummaryPageState();
}

class _MistralAISummaryPageState extends State<MistralAISummaryPage> {
  final MistralAIClient mistralAIClient = MistralAIClient(
    apiKey: '',
  );

  final TextEditingController textEditingController = TextEditingController();
  String summaryResult = '';

  Future<void> summarizeText(String text) async {
    setState(() {
      summaryResult = 'Loading...';
    });
    try {
      final response = await mistralAIClient.chat(
        ChatParams(
          model: 'mistral-small',
          temperature: 1,
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
      appBar: AppBar(title: Text(context.l10n.summaryPageTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter text to summarize',
                  ),
                  minLines: 1,
                  maxLines: 10,
                  onChanged: (value) => textEditingController.text = value,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        summarizeText(textEditingController.text);
                      },
                      child: const Text('Summarize'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final summaryText =
                                summaryTextSample.replaceAll('\n', ' ');
                            // print("summaryText: $summaryText");
                            summarizeText(summaryTextSample);
                          },
                          child: const Text('Summarize sample tex'),
                        ),
                        const SizedBox(height: 20),
                        const SampleTextDialogButton(),
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
      ),
    );
  }
}

class SampleTextDialogButton extends StatelessWidget {
  const SampleTextDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(summaryTextSample),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: const Text('Show sample text'),
    );
  }
}
