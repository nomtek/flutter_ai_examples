import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    required this.value,
    required this.label,
    required this.onChanged,
    super.key,
  });
  final double value;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      label: label,
      onChanged: onChanged,
    );
  }
}
