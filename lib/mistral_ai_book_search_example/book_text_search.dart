import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/models.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/mistral_client.dart';
import 'package:mistral_ai_chat_example_app/mistral_tokenizer/mistral_tokenizer.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

class BookTextSearch {
  BookTextSearch({required this.client, required this.tokenizer});

  final MistralAIClient client;
  final MistralTokenizer tokenizer;
  late SearchData _searchData;
  bool _init = false;

  Future<void> init({bool force = false}) async {
    if (_init && !force) {
      debugPrint('MistralTextSearch already initialized');
      return;
    }
    debugPrint('Initializing MistralTextSearch');
    // the data has to be prepared with the prepare_data.dart script
    // beforehand+
    final fileContent = await rootBundle
        .loadString('assets/20k_leages_under_the_sea_verne.json');
    final json = jsonDecode(fileContent) as Map<String, dynamic>;
    _searchData = SearchData.fromJson(json);
    _init = true;
    debugPrint('Finished initializing MistralTextSearch');
  }

  Future<List<SearchResult>> searchFragment(
    String query, {
    // max number of results to return
    int resultCount = 5,
  }) async {
    final queryEmbedding = await _getEmbedding(query);
    final results = <String, double>{};
    for (var i = 0; i < _searchData.fragments.length; i++) {
      final embedding = _searchData.fragmentEmbeddings[i];
      final similarity = calculateCosineSimilarity(
        queryEmbedding,
        embedding,
      );
      results[_searchData.fragments[i]] = similarity;
    }
    final sortedResults = results.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedResults
        .take(resultCount)
        .map((e) => SearchResult(e.key, e.value))
        .toList();
  }

  Future<List<double>> _getEmbedding(String text) async {
    final queryEmbedding = await mistralAIClient
        .embeddings(EmbeddingParams(model: 'mistral-embed', input: [text]));
    if (queryEmbedding.data.isEmpty) {
      throw Exception('No embedding found for query: $text');
    }
    return queryEmbedding.data.first.embedding;
  }

  List<String> fragments() => _searchData.fragments;

  List<List<int>> fragmentsTokens() => _searchData.fragmentTokens;
}

// cosine similarity
double calculateDotProduct(List<double> vectorA, List<double> vectorB) {
  assert(vectorA.length == vectorB.length, 'Vectors must be of same length');
  var dotProduct = 0.0;
  for (var i = 0; i < vectorA.length; i++) {
    dotProduct += vectorA[i] * vectorB[i];
  }
  return dotProduct;
}

double calculateMagnitude(List<double> vector) => sqrt(
      vector.fold(
        0,
        (previousValue, element) => previousValue + element * element,
      ),
    );

double calculateCosineSimilarity(List<double> vectorA, List<double> vectorB) {
  final dotProduct = calculateDotProduct(vectorA, vectorB);
  final magnitudeA = calculateMagnitude(vectorA);
  final magnitudeB = calculateMagnitude(vectorB);
  return dotProduct / (magnitudeA * magnitudeB);
}
