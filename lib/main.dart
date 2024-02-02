import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistral_ai_chat_example_app/app/app.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    // register the license for the Google Fonts
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const MyApp());
}
