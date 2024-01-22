import 'package:flutter/widgets.dart';
import 'package:mistral_ai_chat_example_app/l10n/l10n.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
