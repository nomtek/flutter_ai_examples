class SummarySettings {
  SummarySettings({
    this.model = 'mistral-small',
    this.temperature = 0.7,
    this.topP = 1,
    this.maxTokens,
    this.safePrompt = false,
    this.randomSeed,
  });
  final String model;
  final double temperature;
  final double topP;
  final int? maxTokens;
  final bool safePrompt;
  final int? randomSeed;
}
