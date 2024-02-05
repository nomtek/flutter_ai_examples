import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/app_settings/app_settings.dart';
import 'package:mistral_ai_chat_example_app/app/router.dart';
import 'package:mistral_ai_chat_example_app/app/theme.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({required this.sharedPreferences, super.key});

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: sharedPreferences),
        ChangeNotifierProvider<AppSettings>(
          create: (context) =>
              AppSettings(context.read<SharedPreferences>())..init(),
        ),
        ProxyProvider0(
          update: (context, __) => MistralAIClient(
            apiKey: context.watch<AppSettings>().mistralApiKey,
          ),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: lightTheme(),
      ),
    );
  }
}
