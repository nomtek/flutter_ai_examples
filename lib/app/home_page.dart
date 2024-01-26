import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/router.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';

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
              title: Text(context.l10n.summaryPageTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAISummaryRoute().go(context),
            ),
            ListTile(
              title: const Text('MistralAI LLM Controller example'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAiLlmControllerRoute().go(context),
            ),
          ],
        ),
      );
}
