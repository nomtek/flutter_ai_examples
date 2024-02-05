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
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 10,
        thumbShape: CustomThumb(
          thumbColor: Theme.of(context).primaryColor,
          spacerColor: Theme.of(context).colorScheme.surface,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        activeTrackColor: Theme.of(context).primaryColor,
        inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
      child: Slider(
        value: value,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomThumb extends SliderComponentShape {
  const CustomThumb({
    required this.spacerColor,
    required this.thumbColor,
    this.thumbWidth = 4,
    this.thumbHeight = 44,
    this.thumbRadius = 2,
    this.space = 6,
  });

  final double thumbWidth;
  final double thumbHeight;
  final double thumbRadius;
  final double space;
  final Color thumbColor;
  final Color spacerColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    //Prepare the spacer rect
    final spacerRect = Rect.fromCenter(
      center: center,
      width: thumbWidth + space,
      height: thumbHeight,
    );
    final spacerPaint = Paint()
      ..color = spacerColor
      ..style = PaintingStyle.fill;

    //Prepare the thumb rect
    final rect = Rect.fromCenter(
      center: center,
      width: thumbWidth,
      height: thumbHeight,
    );
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(thumbRadius),
    );
    final paint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    //Draw the spacer and the thumb on the canvas
    canvas
      ..drawRect(spacerRect, spacerPaint)
      ..drawRRect(rrect, paint);
  }
}
