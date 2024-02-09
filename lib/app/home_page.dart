import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_examples/app/app_settings/app_settings.dart';
import 'package:flutter_ai_examples/app/home_tiles.dart';
import 'package:flutter_ai_examples/app/router.dart';
import 'package:flutter_ai_examples/utils/snackbar_extension.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AI Examples'),
          actions: [
            IconButton(
              onPressed: () => const AppSettingsRoute().go(context),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: MistralAIExamples(),
          ),
        ),
      );
}

class MistralAIExamples extends StatelessWidget {
  const MistralAIExamples({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMistralSetUp = context.select<AppSettings, bool>(
      (appSettings) => appSettings.value.isMistralApiKeyValid(),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HomeSectionTitle(sectionTitle: 'Mistral AI Examples'),
        const SizedBox(height: 16),
        if (!isMistralSetUp) const MistralSetupNotFinished(),
        const SizedBox(height: 16),
        MistralExampleTilesGrid(isEnabled: isMistralSetUp),
      ],
    );
  }
}

class MistralSetupNotFinished extends StatelessWidget {
  const MistralSetupNotFinished({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: 'Please setup Mistral AI API key.\n'
                  'Without it, the examples will not work. \n'
                  'You can get the API key from the ',
              children: [
                TextSpan(
                  text: 'Mistral AI website.',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse('https://console.mistral.ai/');
                      if (!await launchUrl(url)) {
                        if (!context.mounted) return;
                        context.showMessageSnackBar('Could not launch $url');
                      }
                    },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => const AppSettingsRoute().go(context),
            child: const Text('Go to App Settings'),
          ),
        ],
      ),
    );
  }
}

class MistralExampleTilesGrid extends StatelessWidget {
  const MistralExampleTilesGrid({required this.isEnabled, super.key});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnSize = switch (screenWidth) {
      < 600 => 2,
      < 900 => 3,
      < 1500 => 4,
      _ => 8,
    };
    return GridView.count(
      primary: false,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: columnSize,
      shrinkWrap: true,
      childAspectRatio: 1.75,
      children: <Widget>[
        ChatExampleTile(isEnabled: isEnabled),
        TextSummaryTile(isEnabled: isEnabled),
        LllAsControllerTile(isEnabled: isEnabled),
        BookSearchTile(isEnabled: isEnabled),
      ],
    );
  }
}
