import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/app/home_tiles.dart';
import 'package:mistral_ai_chat_example_app/app/router.dart';

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
            child: Column(
              children: [
                HomeSectionTitle(sectionTitle: 'Mistral AI Examples'),
                SizedBox(height: 16),
                MistralExampleTilesGrid(),
              ],
            ),
          ),
        ),
      );
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
