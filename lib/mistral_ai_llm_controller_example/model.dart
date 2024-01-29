class Settings {
  Settings({
    required this.temperature,
    required this.volume,
    this.color = 0,
  });

  final int temperature;
  final int volume;
  final int color;

  @override
  String toString() {
    return 'Settings{ '
        'temperature: $temperature, volume: $volume, color: $color} ';
  }
}
