class SummarySettings {
  SummarySettings({
    this.model = MistralAIModel.mistralSmall,
    this.temperature = 0.7,
    this.topP = 1,
    this.maxTokens,
    this.safePrompt = false,
    this.randomSeed,
  });
  MistralAIModel model;
  double temperature;
  double topP;
  int? maxTokens;
  bool safePrompt;
  int? randomSeed;
}

enum MistralAIModel {
  mistralMedium('mistral-medium'),
  mistralSmall('mistral-small'),
  mistralTiny('mistral-tiny'),
  mistralEmbed('mistral-embed');

  const MistralAIModel(this.name);
  final String name;
}
