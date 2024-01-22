import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mistralai_chat_page.g.dart';

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

class MistralAIChatPage extends HookConsumerWidget {
  const MistralAIChatPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistory = useState(ChatHistory(items: []));
    final messageController = useTextEditingController();

    void addChatHistoryItem(ChatHistoryItem item) {
      chatHistory.value = ChatHistory(
        items: [
          ...chatHistory.value.items,
          item,
        ],
      );
      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mistralAIChatTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatHistory.value.items.length,
                itemBuilder: (context, index) {
                  final item = chatHistory.value.items[index];
                  return ListTile(
                    leading: item.isUserMessage
                        ? const Icon(Icons.person)
                        : const Icon(Icons.computer),
                    title: Text(
                      item.isUserMessage ? 'you' : 'chat',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item.message),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: context.l10n.chatMessageInputHint,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      addChatHistoryItem(
                        ChatHistoryItem(
                          message: messageController.text,
                          isUserMessage: true,
                        ),
                      );
                    },
                  ),
                ),
                onSubmitted: (value) {
                  addChatHistoryItem(
                    ChatHistoryItem(
                      message: value,
                      isUserMessage: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatHistory {
  ChatHistory({required this.items});

  final List<ChatHistoryItem> items;
}

class ChatHistoryItem {
  ChatHistoryItem({
    required this.message,
    required this.isUserMessage,
  });

  final String message;
  final bool isUserMessage;
}
