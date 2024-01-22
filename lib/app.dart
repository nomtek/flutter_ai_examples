import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistral_ai_chat_example_app/router.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
