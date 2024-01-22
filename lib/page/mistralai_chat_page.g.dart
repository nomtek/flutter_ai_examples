// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mistralai_chat_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mistralAIApiKeyHash() => r'dc8137295abbd96e81dd36850c777fc2890a30a6';

/// See also [mistralAIApiKey].
@ProviderFor(mistralAIApiKey)
final mistralAIApiKeyProvider = AutoDisposeProvider<String>.internal(
  mistralAIApiKey,
  name: r'mistralAIApiKeyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mistralAIApiKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MistralAIApiKeyRef = AutoDisposeProviderRef<String>;
String _$mistralAIClientHash() => r'855e9680f78a852aebd0261953c03e6a01d8eef2';

/// See also [mistralAIClient].
@ProviderFor(mistralAIClient)
final mistralAIClientProvider = AutoDisposeProvider<MistralAIClient>.internal(
  mistralAIClient,
  name: r'mistralAIClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mistralAIClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MistralAIClientRef = AutoDisposeProviderRef<MistralAIClient>;
String _$modelNamesHash() => r'9af2f88933436fee8bf0e633bb4a885e7212470d';

/// See also [modelNames].
@ProviderFor(modelNames)
final modelNamesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  modelNames,
  name: r'modelNamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$modelNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ModelNamesRef = AutoDisposeFutureProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
