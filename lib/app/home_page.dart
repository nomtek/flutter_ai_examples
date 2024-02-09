import 'package:flutter/material.dart';
import 'package:flutter_ai_examples/app/app_settings/app_settings.dart';
import 'package:flutter_ai_examples/app/home_tiles.dart';
import 'package:flutter_ai_examples/app/router.dart';
import 'package:provider/provider.dart';

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
        if (isMistralSetUp) const MistralExampleTilesGrid(),
        if (!isMistralSetUp)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Please set up the Mistral AI API key in the app settings.',
              style: TextStyle(fontSize: 20),
            ),
          ),
      ],
    );
  }
}

class MistralExampleTilesGrid extends StatelessWidget {
  const MistralExampleTilesGrid({super.key});

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
      children: const <Widget>[
        ChatExampleTile(),
        TextSummaryTile(),
        LllAsControllerTile(),
        BookSearchTile(),
      ],
    );
  }
}
