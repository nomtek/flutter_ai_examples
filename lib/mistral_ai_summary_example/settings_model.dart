import 'package:flutter/material.dart';

class SummarySettings {
  const SummarySettings({
    this.model = MistralAIModel.mistralSmall,
    this.temperature = 0.7,
    this.topP = 1,
    this.maxTokens,
    this.safePrompt = false,
    this.randomSeed,
  });
  final MistralAIModel model;
  final double temperature;
  final double topP;
  final int? maxTokens;
  final bool safePrompt;
  final int? randomSeed;
}

enum MistralAIModel {
  mistralMedium('mistral-medium'),
  mistralSmall('mistral-small'),
  mistralTiny('mistral-tiny'),
  mistralEmbed('mistral-embed');

  const MistralAIModel(this.name);
  final String name;
}

class SummarySettingsModel extends ChangeNotifier {
  SummarySettingsModel();

  MistralAIModel _model = MistralAIModel.mistralSmall;
  double _temperature = 0.7;
  double _topP = 1;
  int? _maxTokens;
  bool _safePrompt = false;
  int? _randomSeed;

  SummarySettings get settings => SummarySettings(
        model: _model,
        temperature: _temperature,
        topP: _topP,
        maxTokens: _maxTokens,
        safePrompt: _safePrompt,
        randomSeed: _randomSeed,
      );

  void setModel(MistralAIModel model) {
    _model = model;
    notifyListeners();
  }

  void setTemperature(double temperature) {
    _temperature = temperature;
    notifyListeners();
  }

  void setTopP(double topP) {
    _topP = topP;
    notifyListeners();
  }

  void setMaxTokens(int? maxTokens) {
    _maxTokens = maxTokens;
    notifyListeners();
  }

  void setSafePrompt({required bool safePrompt}) {
    _safePrompt = safePrompt;
    notifyListeners();
  }

  void setRandomSeed(int? randomSeed) {
    _randomSeed = randomSeed;
    notifyListeners();
  }
}
