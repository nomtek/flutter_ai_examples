// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
