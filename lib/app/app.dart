import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/router.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
