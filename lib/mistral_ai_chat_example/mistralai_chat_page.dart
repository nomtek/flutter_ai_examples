import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';
import 'package:provider/provider.dart';

part 'chat_model.dart';

class MistralAIChatPage extends StatelessWidget {
  const MistralAIChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ChangeNotifierProvider(
        create: (context) => _ChatModel(context.read()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('MistralAI Chat'),
            actions: const [
              _ChatSettingsButton(),
            ],
          ),
          body: const SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _ChatMessagesList(),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: _ChatMessageInput(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// opens bottom sheet with chat settings
class _ChatSettingsButton extends StatelessWidget {
  const _ChatSettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        final chatModel = context.read<_ChatModel>();
        _showSettingsBottomSheet(context, chatModel);
      },
    );
  }

  Future<void> _showSettingsBottomSheet(
    BuildContext context,
    _ChatModel chatModel,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: chatModel,
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),
                const _StreamingModeSwitch(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// changes if the chat should be in streaming mode
class _StreamingModeSwitch extends StatelessWidget {
  const _StreamingModeSwitch();

  @override
  Widget build(BuildContext context) {
    final isStreaming = context.select((_ChatModel model) => model.streaming);
    return SwitchListTile(
      title: const Text('Streaming mode'),
      value: isStreaming,
      onChanged: (value) {
        context.read<_ChatModel>().streaming = value;
      },
    );
  }
}

// input field where user can type message to chat
class _ChatMessageInput extends StatefulWidget {
  const _ChatMessageInput();

  @override
  State<_ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<_ChatMessageInput> {
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
    final showLoading = context.select(
      (_ChatModel model) => model.waitingForResponse,
    );
    return TextField(
      focusNode: focusNode,
      textInputAction: TextInputAction.send,
      controller: messageController,
      decoration: InputDecoration(
        hintText: 'Type your message here...',
        suffixIcon: showLoading
            ? const _TextFieldProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => addMessage(context, messageController.text),
              ),
      ),
      onSubmitted: (value) => addMessage(context, value),
    );
  }

  void addMessage(BuildContext context, String message) {
    final chatModel = context.read<_ChatModel>();
    final canAddMessage = !chatModel.waitingForResponse;
    if (!canAddMessage) {
      // skip adding new message if there is generation in progress
      return;
    }
    chatModel.add(_ChatHistoryItem.userMessage(message));
    messageController.clear();
    // focus on input field because clearing input field removes focus
    // we want to be able to type next message without clicking on input field
    focusNode.requestFocus();
  }
}

// progress indicator for text field
class _TextFieldProgressIndicator extends StatelessWidget {
  const _TextFieldProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const CircularProgressIndicator(),
    );
  }
}

// list of chat messages
class _ChatMessagesList extends StatefulWidget {
  const _ChatMessagesList();

  @override
  State<_ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<_ChatMessagesList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottomAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatHistory = context.select(
      (_ChatModel model) => model.chatHistory,
    );

    // schedule scroll to bottom after build
    _scrollToBottomAfterBuild();

    return ListView.builder(
      controller: _scrollController,
      itemCount: chatHistory.length,
      itemBuilder: (context, index) {
        final item = chatHistory[index];
        return _ChatHistoryListTile(item: item);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// list tile for chat history item.
// displays message from user or chat.
class _ChatHistoryListTile extends StatelessWidget {
  const _ChatHistoryListTile({required this.item});

  final _ChatHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tileColor = item.isUserMessage
        ? colorScheme.secondaryContainer
        : colorScheme.background;
    final iconData = item.isUserMessage ? Icons.person : Icons.computer;
    final username = item.isUserMessage ? 'You' : 'Chat';

    return ListTile(
      tileColor: tileColor,
      isThreeLine: true,
      leading: Icon(iconData),
      title: Text(username),
      subtitle: Text(item.message),
    );
  }
}
