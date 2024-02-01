import 'dart:convert';
import 'dart:io';

import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/models.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/text_chunk_splitter.dart';
import 'package:mistral_ai_chat_example_app/mistral_tokenizer/mistral_tokenizer.dart';
import 'package:mistralai_client_dart/mistralai_client_dart.dart';

final mistralTokenizer = MistralTokenizer.fromBase64();

const String mistralAIApiKey = String.fromEnvironment('MISTRAL_AI_API_KEY');

final mistralAIClient = MistralAIClient(apiKey: mistralAIApiKey);

// use this command to run this file from the root of the project:
// dart run --define=MISTRAL_AI_API_KEY=YourAPIKey lib/mistral_ai_book_search_example/prepare_data.dart
void main() async {
  final mainStopWatch = Stopwatch()..start();
  const fileName = '20k_leages_under_the_sea_verne';
  final textFile = File('assets/$fileName.txt');
  _log('=== Preparing search data ===');
  _log('text file: ${textFile.absolute.path}');
  _log('=======');

  final searchData = await prepareSearchData(textFile);

  _log('=== Search data generated ===');
  _log('fragments length: ${searchData.fragments.length}');
  _log('fragments tokens length: ${searchData.fragmentTokens.length}');
  _log('embeddings length: ${searchData.fragmentEmbeddings.length}');
  _log('=======');
  final jsonFile = File('assets/$fileName.json')
    ..writeAsStringSync(jsonEncode(searchData.toJson()));
  _log('Results saved to ${jsonFile.absolute.path}');

  mainStopWatch.stop();
  _log('Finished in ${mainStopWatch.elapsed}');
}

int _lastEmbeddingRequestTimeMs = 0;

// get embeddings with a delay between requests to not exceed the
// MistralAI API rate limit of 2 requests per second
Future<List<List<double>>> getEmbedding(List<String> texts) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  // 500ms is the minimum time between requests
  final delay = 500 - (now - _lastEmbeddingRequestTimeMs);
  if (delay > 0) {
    await Future.delayed(Duration(milliseconds: delay), () {});
  }

  final embeddingsResult = await mistralAIClient
      .embeddings(EmbeddingParams(model: 'mistral-embed', input: texts));
  _lastEmbeddingRequestTimeMs = DateTime.now().millisecondsSinceEpoch;
  if (embeddingsResult.data.isEmpty) {
    throw Exception('No embedding found for query');
  }
  return embeddingsResult.data.map((e) => e.embedding).toList();
}

// prepare data for search
// takes a text file and returns a SearchData object
// SearchData contains the text fragments, their tokens and embeddings
Future<SearchData> prepareSearchData(
  File textFile, {
  // process only first n fragments - for testing
  int? processFirstNFragments,
}) async {
  assert(
    processFirstNFragments == null || processFirstNFragments > 0,
    'processFirstNFragments must be null or > 0',
  );
  if (!textFile.existsSync()) {
    throw Exception(
      'File does not exist: ${textFile.path}. Check for typos. '
      'Current directory: ${Directory.current.path}',
    );
  }
  // initialize space for fragments, tokens and embeddings
  final fragmentsTokens = <List<int>>[];
  final embeddings = <List<double>>[];
  var fragments = <String>[];

  await timedOperation('Load text file and split to fragments', () async {
    final bookText = await textFile.readAsString();
    final splitter = TextToChunkSplitter();
    final splittedText = splitter.split(bookText);
    if (processFirstNFragments != null) {
      fragments = splittedText.take(processFirstNFragments).toList();
    } else {
      fragments = splittedText;
    }
  });

  // tokenize fragments
  timedOperationSync('Tokenization', () {
    final splitLength = fragments.length;
    for (var i = 0; i < splitLength; i++) {
      final fragment = fragments[i];
      // encode fragment to tokens and add to list
      final tokenizedFragment = mistralTokenizer.encode(fragment);
      fragmentsTokens.add(tokenizedFragment);
      final number = i + 1;
      _log('tokenized fragment $number/$splitLength');
    }
  });

  // get embeddings for fragments
  //
  // batch size value from error message of MistralAI API
  final fragmentsBatches = <List<String>>[];
  timedOperationSync('Batches for embeddings creation', () {
    const batchSize = 16384;
    var batchCurrentSize = 0;
    var batch = <String>[];
    var i = 0;
    while (i < fragmentsTokens.length) {
      final fragmentTokens = fragmentsTokens[i];
      final tokensLength = fragmentTokens.length;
      if (batchCurrentSize + tokensLength > batchSize) {
        // batch if full - add to batches
        // and create new batch
        fragmentsBatches.add(batch);
        batch = [];
        batchCurrentSize = 0;
      } else {
        batch.add(fragments[i]);
        batchCurrentSize += tokensLength;
        i++;
      }
    }
    // add last batch
    if (batch.isNotEmpty) {
      fragmentsBatches.add(batch);
    }
  });

  // get embeddings for batches
  await timedOperation('Embeddings for all batches creation', () async {
    for (var i = 0; i < fragmentsBatches.length; i++) {
      final batch = fragmentsBatches[i];
      final batchEmbeddings = await getEmbedding(batch);
      embeddings.addAll(batchEmbeddings);
      _log('Embeddings for batch ${i + 1}/${fragmentsBatches.length} created');
    }
  });

  checkLengths([fragments, fragmentsTokens, embeddings]);
  return SearchData(fragments, fragmentsTokens, embeddings);
}

void _log(String message) {
  // ignore: avoid_print
  print(message);
}

Future<void> timedOperation(
  String operationName,
  Future<void> Function() operation,
) async {
  final timer = Stopwatch()..start();
  await operation();
  timer.stop();
  _log('$operationName completed in ${timer.elapsedMilliseconds}ms');
}

void timedOperationSync(
  String operationName,
  void Function() operation,
) {
  final timer = Stopwatch()..start();
  operation();
  timer.stop();
  _log('$operationName completed in ${timer.elapsedMilliseconds}ms');
}

void checkLengths(List<List<dynamic>> lists) {
  final length = lists.first.length;
  for (final list in lists) {
    if (list.length != length) {
      throw Exception('Lists must have the same length');
    }
  }
}
