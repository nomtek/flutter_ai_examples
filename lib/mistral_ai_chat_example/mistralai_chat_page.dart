import 'package:flutter/material.dart';

import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

String mistralAIApiKey() => const String.fromEnvironment('MISTRAL_AI_API_KEY');

MistralAIClient mistralAIClient() => MistralAIClient(apiKey: mistralAIApiKey());

Future<List<String>> modelNames() async {
  final client = mistralAIClient();
  return (await client.listModels()).data.map((e) => e.id).toList();
}

class MistralAIChatPage extends StatelessWidget {
  const MistralAIChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    var chatHistory = ChatHistory(items: []);
    final messageController = TextEditingController();

    void addChatHistoryItem(ChatHistoryItem item) {
      chatHistory = ChatHistory(
        items: [
          ...chatHistory.items,
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
                itemCount: chatHistory.items.length,
                itemBuilder: (context, index) {
                  final item = chatHistory.items[index];
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
