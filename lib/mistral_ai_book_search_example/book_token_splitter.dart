import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:mistralai_client_dart/mistralai_client_dart.dart';

final RegExp sentenceRegex = RegExp(r"(\w|\s|,|')+[。.?!]*\s*");

class TextFileToFragmentsSplitter {
  // splits text into smaller chunks based on the number of tokens per chunk
  Stream<String> split(File textFile, {int tokensPerChunk = 256}) {
    // TODO: implement split
    // split text into sentences
    //
    // each sentence should be converted to tokens
    //
    // each split should contain tokensPerChunk tokens
    //
    // for each sentence, calculate tokens
    //
    // for each sentence if tokens < tokensPerChunk then add to current chunk
    //
    // if sentence is too long, split into smaller chunks
    // (just cut it somewhere)
    //
    // else add to new chunk
    //
    // return chunks

    // temporary implementation
    // for now just split into lines
    return textFile.openRead().map(utf8.decode).transform(const LineSplitter());
  }
}

class MistralTextSearch {
  MistralTextSearch({required this.client});

  final MistralAIClient client;
  final List<Fragment> _fragments = [];

  Future<void> init() async {}

  Future<SearchResult> searchFragment(String query) async {
    final queryEmbedding = await _getQueryEmbedding(query);
    final results = <String, double>{};
    for (final fragment in _fragments) {
      final similarity = calculateCosineSimilarity(
        queryEmbedding,
        fragment.embedding,
      );
      results[fragment.text] = similarity;
    }
    final sortedResults = results.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return SearchResult(sortedResults.first.key, sortedResults.first.value);
  }

  Future<List<double>> _getQueryEmbedding(String query) async {
    final queryEmbedding = await client
        .embeddings(EmbeddingParams(model: 'mistral-embed', input: [query]));
    if (queryEmbedding.data.isEmpty) {
      throw Exception('No embedding found for query: $query');
    }
    return queryEmbedding.data.first.embedding;
  }
}

// consine similarity

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

// data types

// keeps information about a fragment of text and it's embeddings
class Fragment {
  Fragment(this.text, this.embedding);

  final String text;
  final List<double> embedding;
}

class SearchResult {
  SearchResult(this.text, this.similarity);

  final String text;
  final double similarity;
}
