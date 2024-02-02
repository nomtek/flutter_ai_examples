import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            ListTile(
              title: const Text('MistralAI Chat example'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAIChatRoute().go(context),
            ),
            ListTile(
              title: const Text('MistralAI Summary example'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAISummaryRoute().go(context),
            ),
            ListTile(
              title: const Text('MistralAI LLM Controller example'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAILlmControllerRoute().go(context),
            ),
            ListTile(
              title: const Text('MistralAI Book Search example'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAIBookSearchRoute().go(context),
            ),
          ],
        ),
      );
}
