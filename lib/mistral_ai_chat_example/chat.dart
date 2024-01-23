import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

/// Keeps state of the chat
class ChatModel extends ChangeNotifier implements ValueListenable<Chat> {
  ChatModel(this._mistralAIClient);

  final MistralAIClient _mistralAIClient;
  // internal queue to store chat history items
  final _items = Queue<ChatHistoryItem>();
  StreamSubscription<ChatCompletionChunkResult>? _streamSub;

  @override
  Chat get value => Chat(
        chatHistory: ChatHistory(
          // make sure to not allow modification on the chat history items
          items: List.unmodifiable(_items.toList()),
        ),
        waitingForResponse: _isGenerationInProgress,
      );

  void add(ChatHistoryItem item) {
    if (_streamSub != null) {
      // skip adding new message if there is a stream subscription
      return;
    }
    _items.addLast(item);
    notifyListeners();
    _streamSub = _mistralAIClient
        .chatStream(
          ChatParams(
            model: 'mistral-small',
            messages: [
              // convert chat history items to chat messages
              // to provide them to the ai chat
              // this is needed to keep pass the context to the ai chat
              ..._items.map(_historyItemToChatMessage),
            ],
          ),
        )
        /// delay the response to make it look like a real chat
        .asyncMap(
          (event) =>
              Future.delayed(const Duration(milliseconds: 150), () => event),
        )
        .listen(
      (event) {
        // append bot message to the last user message
        //
        // if there is user message, just add bot message
        //
        // if there is no user message,
        // append bot message to the last bot message
        final botMessage = event.choices[0].delta?.content;
        debugPrint('${DateTime.now()}: $botMessage');
        if (botMessage != null) {
          if (_items.last.isUserMessage) {
            _items.addLast(ChatHistoryItem.botMessage(botMessage));
          } else {
            final historyItem = _items.removeLast();
            _items.addLast(
              ChatHistoryItem.botMessage('${historyItem.message}$botMessage'),
            );
          }
          // notify about new message added/updated
          notifyListeners();
          debugPrint('notifyListeners');
        }
      },
      onDone: _generationDone,
    );
  }

  bool get _isGenerationInProgress => _streamSub != null;

  void _generationDone() {
    _streamSub = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_streamSub?.cancel());
    super.dispose();
  }

  ChatMessage _historyItemToChatMessage(ChatHistoryItem item) => ChatMessage(
        role: item.isUserMessage ? 'user' : 'assistant',
        content: item.message,
      );
}

/// State of the chat
@immutable
class Chat {
  const Chat({
    required this.chatHistory,
    this.waitingForResponse = false,
  });

  final ChatHistory chatHistory;
  final bool waitingForResponse;
}

@immutable
class ChatHistory {
  const ChatHistory({required this.items});

  final List<ChatHistoryItem> items;
}

class ChatHistoryItem {
  ChatHistoryItem({
    required this.message,
    required this.isUserMessage,
  });

  factory ChatHistoryItem.userMessage(String message) => ChatHistoryItem(
        message: message,
        isUserMessage: true,
      );

  factory ChatHistoryItem.botMessage(String message) => ChatHistoryItem(
        message: message,
        isUserMessage: false,
      );

  String message;
  final bool isUserMessage;
}
