// keeps information about a fragment of text and it's embeddings
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// answer to the question about the book
class Answer {
  Answer({
    required this.text,
    required this.question,
    required this.keywords,
    required this.fragmentSimilarities,
  });

  final String text;
  final String question;
  final List<String> keywords;
  final List<FragmentSimilarity> fragmentSimilarities;
}

class FragmentSimilarity {
  FragmentSimilarity(this.fragmentIndex, this.text, this.similarity);

  final int fragmentIndex;
  final String text;
  final double similarity;

  @override
  String toString() =>
      'FragmentSimilarity(text: $text, similarity: $similarity)';
}

// keeps information about the book that is used for searching
@JsonSerializable()
class SearchData {
  SearchData(this.fragments, this.fragmentTokens, this.fragmentEmbeddings);

  factory SearchData.fromJson(Map<String, dynamic> json) =>
      _$SearchDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchDataToJson(this);

  final List<String> fragments;
  final List<List<int>> fragmentTokens;
  final List<List<double>> fragmentEmbeddings;
}
