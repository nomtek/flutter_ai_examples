import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/algebra.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/models.dart';
import 'package:mistral_ai_chat_example_app/mistral_tokenizer/mistral_tokenizer.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

// loads and keeps information about the book that is used for searching
// and provides methods to find answers to questions
class BookSearch {
  BookSearch({
    required this.mistralAIClient,
    required this.tokenizer,
    this.bookTitle = 'Twenty Thousands Leagues Under the Sea',
    this.bookSearchDataAssetPath = 'assets/20k_leages_under_the_sea_verne.json',
  });

  final MistralAIClient mistralAIClient;
  final MistralTokenizer tokenizer;
  late SearchData _searchData;
  bool _init = false;

  // change this to change the book name
  final String bookTitle;
  // change this to change the book data (generated with prepare_data.dart)
  final String bookSearchDataAssetPath;

  Future<void> init({bool force = false}) async {
    if (_init && !force) {
      debugPrint('BookSearch already initialized');
      return;
    }
    debugPrint('Initializing BookSearch');
    final fileContent = await rootBundle.loadString(bookSearchDataAssetPath);
    final json = jsonDecode(fileContent) as Map<String, dynamic>;
    _searchData = SearchData.fromJson(json);
    _init = true;
    debugPrint('Finished initializing BookSearch');
  }

  Future<List<String>> _createKeywordsFromQuestion(String userQuestion) async {
    const assistantRole = '''
You are a helpful assistant designed to create keywords from a question.
The keywords are used to search for the answer in the book.
Return the keywords in a list of strings: ["keyword1", "keyword2", ...]
Do not return anything else than list. 
Do not explain anything. 
''';
    final response = await mistralAIClient.chat(
      ChatParams(
        model: 'mistral-tiny',
        messages: [
          const ChatMessage(role: 'system', content: assistantRole),
          ChatMessage(role: 'user', content: userQuestion),
        ],
        // temperature is set to 0.1 and not 0
        // because Mistral API does not allow 0
        // when topP is not 1 (default value)
        temperature: 0.1, // less randomness
        topP: 0.1, // choose from top 10% of the most likely tokens
      ),
    );
    final content = response.choices.first.message.content;

    // extract the list of keywords from the response
    // (ai can return more text than a list)
    final regex = RegExp(r'\[.*?\]');
    final match = regex.firstMatch(content);
    final listAsString = match?.group(0);
    if (listAsString == null) {
      return [];
    }
    return List<String>.from(jsonDecode(listAsString) as List<dynamic>);
  }

  Future<String> _getAnswerToQuestion({
    required String userQuestion,
    required List<String> keywordsFromQuestion,
    required List<String> fragments,
  }) async {
    final answerRole = '''
You are a helpful assistant designed to answer questions from a book.
You are given list of book fragments related to the question.
Use knowledge only from given fragments to answer the question.
Here are some keywords related to question: ${keywordsFromQuestion.join(', ')}.
Return the answer as a plain text.
''';
    final response = await mistralAIClient.chat(
      ChatParams(
        model: 'mistral-medium',
        messages: [
          ChatMessage(role: 'system', content: answerRole),
          ...fragments.map((e) => ChatMessage(role: 'system', content: e)),
          ChatMessage(role: 'user', content: userQuestion),
        ],
        // temperature is set to 0.1 and not 0
        // because Mistral API does not allow 0
        // when topP is not 1 (default value)
        temperature: 0.1, // less randomness
        topP: 0.5, // choose from top 50% of the most likely tokens
      ),
    );
    return response.choices.first.message.content;
  }

  // step 1: Take question about book from user
  //  and ask AI to create keywords from it
  // step 2: Search for fragments with keywords
  // step 3: Take fragments and ask AI to answer original question
  Future<Answer> findAnswer(
    String question, {
    // max number of fragments to use for answer
    int resultCount = 5,
  }) async {
    final keywords = await _createKeywordsFromQuestion(question);
    final keywordsString = keywords.join(' ');
    debugPrint('keywords: $keywordsString');
    // Get embedding for question + keywords.
    // Keywords are added to the question to help AI
    // find most relevant fragments. To make a stronger connection
    // between question and keywords we add them to the question.
    //
    // This will be used to find the most similar fragments
    // to the question
    // (we use the same embedding model as for the book fragments).
    //
    // Later on we will use found fragments to answer the question using AI.
    final questionEmbedding = await _getEmbedding('$question $keywordsString');
    final fragmentToQuestionSimilarities = <FragmentSimilarity>[];
    for (var i = 0; i < _searchData.fragments.length; i++) {
      final fragmentEmbedding = _searchData.fragmentEmbeddings[i];
      final similarity = calculateCosineSimilarity(
        questionEmbedding,
        fragmentEmbedding,
      );
      fragmentToQuestionSimilarities.add(
        FragmentSimilarity(i, _searchData.fragments[i], similarity),
      );
    }
    // sort by similarity descending
    final sortedSimilarities = fragmentToQuestionSimilarities
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
    final mostRelevantSimilarities =
        sortedSimilarities.take(resultCount).toList();
    final mostRelevantFragments =
        mostRelevantSimilarities.map((e) => e.text).toList();
    final answer = await _getAnswerToQuestion(
      userQuestion: question,
      keywordsFromQuestion: keywords,
      fragments: mostRelevantFragments,
    );

    return Answer(
      text: answer,
      question: question,
      keywords: keywords,
      fragmentSimilarities: mostRelevantSimilarities,
    );
  }

  Future<List<double>> _getEmbedding(String text) async {
    final queryEmbedding = await mistralAIClient
        .embeddings(EmbeddingParams(model: 'mistral-embed', input: [text]));
    if (queryEmbedding.data.isEmpty) {
      throw Exception('No embedding found for text: $text');
    }
    return queryEmbedding.data.first.embedding;
  }

  List<String> fragments() => _searchData.fragments;

  List<List<int>> fragmentsTokens() => _searchData.fragmentTokens;
}
