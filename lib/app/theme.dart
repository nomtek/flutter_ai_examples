import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
    sliderTheme: baseTheme.sliderTheme.copyWith(
      trackHeight: 10,
      thumbShape: CustomThumb(
        thumbColor: baseTheme.primaryColor,
        spacerColor: baseTheme.colorScheme.surface,
      ),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      activeTrackColor: baseTheme.primaryColor,
      inactiveTrackColor: baseTheme.primaryColor.withOpacity(0.5),
    ),
  );
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
    return Size(thumbWidth + space * 2, thumbHeight);
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

/// Theme with a darker background color.
//
// This theme is not fully complete for all the components.
class DarkerBackgroundTheme extends StatelessWidget {
  const DarkerBackgroundTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // This theme is not fully complete.
    // There are updates to the components that are used
    // in the current examples.
    // If any component is not looking good then update it here
    final baseTheme = Theme.of(context);
    final darkBackgroundThemeData = ThemeData.from(
      colorScheme: baseTheme.colorScheme.copyWith(
        // change the background color to a darker color for all widgets
        // using this color
        background: baseTheme.colorScheme.surfaceVariant,
        //change the surface tint for alert dialogs
        surfaceTint: baseTheme.colorScheme.surfaceVariant,
      ),
      textTheme: baseTheme.textTheme,
    ).copyWith(
      // updates to the components theme to better work with the new
      // background color
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: baseTheme.colorScheme.surfaceVariant,
      ),
      listTileTheme: baseTheme.listTileTheme.copyWith(
        tileColor: baseTheme.colorScheme.surface,
      ),
    );
    return Theme(data: darkBackgroundThemeData, child: child);
  }
}
