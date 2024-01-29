import 'dart:core';

//TODO(mgruchala): Add tests
String? extractJson(String input) {
  final regExp = RegExp(r'\{[^}]*\}');
  final Match? match = regExp.firstMatch(input);

  return match?.group(0);
}
