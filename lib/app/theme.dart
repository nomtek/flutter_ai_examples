import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
    textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
  );
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
