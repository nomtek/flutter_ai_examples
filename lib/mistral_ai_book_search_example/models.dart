// keeps information about a fragment of text and it's embeddings
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class SearchResult {
  SearchResult(this.text, this.similarity);

  final String text;
  final double similarity;

  @override
  String toString() => 'SearchResult(text: $text, similarity: $similarity)';
}

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
