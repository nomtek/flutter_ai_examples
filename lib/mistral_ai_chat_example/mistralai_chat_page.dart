import 'package:flutter/material.dart';

import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/chat.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:provider/provider.dart';

// TODO(lgawron): think of some loading indicator
// TODO(lgawron): think of some error handling
// TODO(lgawron): add some tests


const String mistralAIApiKey = String.fromEnvironment('MISTRAL_AI_API_KEY');

final mistralAIClient = MistralAIClient(apiKey: mistralAIApiKey);

class MistralAIChatPage extends StatelessWidget {
  const MistralAIChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ChangeNotifierProvider(
        create: (context) => ChatModel(mistralAIClient),
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.mistralAIChatTitle),
          ),
          body: const SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ChatMessagesList(),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ChatMessageInput(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessageInput extends StatefulWidget {
  const ChatMessageInput({super.key});

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  late final TextEditingController messageController;
  late final FocusNode focusNode;

  @override
  void initState() {
    messageController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      textInputAction: TextInputAction.send,
      controller: messageController,
      decoration: InputDecoration(
        hintText: context.l10n.chatMessageInputHint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => addMessage(context, messageController.text),
        ),
      ),
      onSubmitted: (value) => addMessage(context, value),
    );
  }

  void addMessage(BuildContext context, String message) {
    final historyItem = ChatHistoryItem(
      message: message,
      isUserMessage: true,
    );
    context.read<ChatModel>().add(historyItem);
    messageController.clear();
    focusNode.requestFocus();
  }
}

class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({super.key});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _scrollListener() {
    debugPrint('scrollListener');
    debugPrint('scrollController.offset: ${_scrollController.offset}');
    debugPrint(
        'scrollController.position.maxScrollExtent: ${_scrollController.position.maxScrollExtent}');
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatHistory =
        context.select((ChatModel model) => model.value.chatHistory);

    _scrollToBottom();

    return ListView.builder(
      controller: _scrollController,
      itemCount: chatHistory.items.length,
      itemBuilder: (context, index) {
        final item = chatHistory.items[index];
        return Container(
          color: item.isUserMessage ? Colors.grey[200] : Colors.white,
          child: ListTile(
            isThreeLine: true,
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
          ),
        );
      },
    );
  }
}
