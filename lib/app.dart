import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app.g.dart';

@riverpod
String mistralAIApiKey(MistralAIApiKeyRef ref) =>
    const String.fromEnvironment('MISTRAL_AI_API_KEY');

@riverpod
MistralAIClient mistralAIClient(MistralAIClientRef ref) =>
    MistralAIClient(apiKey: ref.watch(mistralAIApiKeyProvider));

@riverpod
Future<List<String>> modelNames(ModelNamesRef ref) async {
  final client = ref.watch(mistralAIClientProvider);
  return (await client.listModels()).data.map((e) => e.id).toList();
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelNames = ref.watch(modelNamesProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Column(
            children: [
              modelNames.when(
                data: (data) => Text(data.toString()),
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
