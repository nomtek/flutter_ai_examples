import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistral_ai_chat_example_app/router.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: ListView(
          children: [
            ListTile(
              title: Text(context.l10n.mistralAIChatTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => const MistralAIChatRoute().go(context),
            ),
          ],
        ),
      );
}
