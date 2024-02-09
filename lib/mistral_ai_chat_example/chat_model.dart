part of 'mistralai_chat_page.dart';

/// Keeps state of the chat
class _ChatModel extends ChangeNotifier {
  _ChatModel(this._mistralAIClient);

  final MistralAIClient _mistralAIClient;

  // internal queue to store chat history items
  final _chatHistory = Queue<_ChatHistoryItem>();

  // make sure to not allow modification on the chat history items
  List<_ChatHistoryItem> get chatHistory => List.unmodifiable(
        _chatHistory.toList(),
      );

  // stream subscription to cancel it on dispose
  StreamSubscription<ChatCompletionChunkResult>? _streamSub;

  bool _isGenerationInProgress = false;

  bool get waitingForResponse => _isGenerationInProgress;

  // keep track of the error to show it on the screen
  String? error;

  // keep track of the streaming state setting
  bool _streaming = true;
  bool get streaming => _streaming;
  set streaming(bool value) {
    _streaming = value;
    notifyListeners();
  }

  void add(_ChatHistoryItem item) {
    if (_isGenerationInProgress) {
      // skip adding new message if there is a stream subscription
      return;
    }
    _isGenerationInProgress = true;
    error = null;
    _chatHistory.addLast(item);
    // notify ui about added user's message and updating loading state
    notifyListeners();

    // TODO(lgawron): consider using tokenizer to count tokens
    final params = ChatParams(
      model: 'mistral-small',
      messages: [
        // TODO(lgawron): consider taking only subset of the chat history
        // to reduce the payload size, improve performance and reduce cost

        // convert chat history items to chat messages
        // to provide them to the ai chat
        // this is needed to keep pass the context to the ai chat
        ..._chatHistory.map(_historyItemToChatMessage),
      ],
    );

    if (streaming) {
      _sendToMistralStreaming(params);
    } else {
      _sendToMistral(params);
    }
  }

  void _sendToMistral(ChatParams params) {
    _mistralAIClient.chat(params).then(
      (value) {
        final botMessage = value.choices[0].message.content;
        _chatHistory.addLast(_ChatHistoryItem.botMessage(botMessage));
        _generationDone();
      },
      onError: _handleError,
    );
  }

  void _sendToMistralStreaming(ChatParams params) {
    _streamSub = _mistralAIClient
        .chatStream(params)

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
        if (botMessage != null) {
          if (_chatHistory.last.isUserMessage) {
            _chatHistory.addLast(_ChatHistoryItem.botMessage(botMessage));
          } else {
            final historyItem = _chatHistory.removeLast();
            _chatHistory.addLast(
              _ChatHistoryItem.botMessage('${historyItem.message}$botMessage'),
            );
          }
          // notify about new message added/updated
          notifyListeners();
        }
      },
      onDone: _generationDone,
      onError: _handleError,
    );
  }

  void _handleError(dynamic error) {
    final errorText = error.toString();
    debugPrint('Error: $errorText');
    _setError(getNiceErrorMessage(error));
  }

  void _generationDone() {
    // cleanup after generation is done
    _isGenerationInProgress = false;
    _streamSub = null;
    notifyListeners();
  }

  void _setError(String error) {
    this.error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_streamSub?.cancel());
    super.dispose();
  }

  ChatMessage _historyItemToChatMessage(_ChatHistoryItem item) {
    return ChatMessage(
      role: item.isUserMessage ? 'user' : 'assistant',
      content: item.message,
    );
  }
}

class _ChatHistoryItem {
  _ChatHistoryItem({
    required this.message,
    required this.isUserMessage,
  });

  factory _ChatHistoryItem.userMessage(String message) => _ChatHistoryItem(
        message: message,
        isUserMessage: true,
      );

  factory _ChatHistoryItem.botMessage(String message) => _ChatHistoryItem(
        message: message,
        isUserMessage: false,
      );

  String message;
  final bool isUserMessage;
}
