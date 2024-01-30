// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fragment _$FragmentFromJson(Map<String, dynamic> json) => Fragment(
      json['text'] as String,
      (json['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['tokens'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$FragmentToJson(Fragment instance) => <String, dynamic>{
      'text': instance.text,
      'embedding': instance.embedding,
      'tokens': instance.tokens,
    };

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
      (json['fragments'] as List<dynamic>).map((e) => e as String).toList(),
      (json['fragmentTokens'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
      (json['fragmentEmbeddings'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{
      'fragments': instance.fragments,
      'fragmentTokens': instance.fragmentTokens,
      'fragmentEmbeddings': instance.fragmentEmbeddings,
    };
