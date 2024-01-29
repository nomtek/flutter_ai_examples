import 'dart:core';
import 'dart:ui';

// TODO(mgruchala): Add tests.
String? extractJson(String input) {
  final regExp = RegExp(r'\{[^}]*\}');
  final Match? match = regExp.firstMatch(input);

  return match?.group(0);
}

// TODO(mgruchala): Add tests.

/// Returns a `Color` object corresponding to the hexadecimal color string,
///
/// Supported formats:
/// 0XAARRGGBB
/// 0XRRGGBB
/// AARRGGBB
/// RRGGBB
/// #AARRGGBB
/// #RRGGBB
///
/// Throws an exception if the input string is not a valid color representation.
Color getColorFromHex(String hexColor) {
  try {
    var colorString = hexColor.toUpperCase().replaceAll('#', '');

    if (colorString.length == 10 && colorString.startsWith('0X')) {
      colorString = colorString.substring(2);
    } else if (colorString.length == 8 && colorString.startsWith('0X')) {
      colorString = colorString.substring(2);
      colorString = 'FF$colorString';
    } else if (colorString.length == 6) {
      colorString = 'FF$colorString';
    }
    return Color(int.parse('0x$colorString'));
  } catch (e) {
    throw Exception('Invalid color: $hexColor');
  }
}
