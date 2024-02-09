import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// key for the shared preferences where the API key is stored
const _sharedPrefsMistralApiKey = 'mistralApiKey';

// environment variable for the Mistral AI API key
const String _mistralAIApiKeyEnvVar =
    String.fromEnvironment('MISTRAL_AI_API_KEY');

class AppSettings extends ValueNotifier<AppSettingsData> {
  AppSettings(this._sharedPreferences)
      : super(const AppSettingsData(mistralApiKey: ''));

  final SharedPreferences _sharedPreferences;

  String get mistralApiKey => value.mistralApiKey;

  set mistralApiKey(String apiKey) {
    value = value.copyWith(apiKey: apiKey);
  }

  // initialize the app settings from the shared preferences
  void init() {
    if (!_sharedPreferences.containsKey(_sharedPrefsMistralApiKey)) {
      // if there is no persisted API key,
      // try to set the environment variable one as a fallback
      _sharedPreferences.setString(
        _sharedPrefsMistralApiKey,
        _mistralAIApiKeyEnvVar,
      );
    }
    mistralApiKey =
        _sharedPreferences.getString(_sharedPrefsMistralApiKey) ?? '';
  }
}

@immutable
class AppSettingsData {
  const AppSettingsData({
    required this.mistralApiKey,
  });

  final String mistralApiKey;

  // for now check if the API key is not empty
bool isMistralApiKeyValid() => mistralApiKey.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsData && other.mistralApiKey == mistralApiKey;
  }

  @override
  int get hashCode => mistralApiKey.hashCode;

  AppSettingsData copyWith({
    String? apiKey,
  }) {
    return AppSettingsData(
      mistralApiKey: apiKey ?? mistralApiKey,
    );
  }
}
