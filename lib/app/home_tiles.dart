import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_ai_examples/app/router.dart';

class LllAsControllerTile extends StatelessWidget {
  const LllAsControllerTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeExampleTile(
      title: 'LLM as Controller',
      icon: Symbols.home,
      gradientColors: const [
        Colors.red,
        Colors.orangeAccent,
      ],
      onTap: () => const MistralAILlmControllerRoute().go(context),
    );
  }
}

class TextSummaryTile extends StatelessWidget {
  const TextSummaryTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeExampleTile(
      title: 'Text Summary',
      icon: Symbols.summarize,
      gradientColors: const [
        Colors.green,
        Colors.yellow,
      ],
      onTap: () => const MistralAISummaryRoute().go(context),
    );
  }
}

class ChatExampleTile extends StatelessWidget {
  const ChatExampleTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeExampleTile(
      title: 'Chat',
      icon: Symbols.forum,
      gradientColors: [
        Colors.blue[800]!,
        Colors.blue[400]!,
      ],
      onTap: () => const MistralAIChatRoute().go(context),
    );
  }
}

class BookSearchTile extends StatelessWidget {
  const BookSearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeExampleTile(
      title: 'Book Search',
      icon: Symbols.book,
      gradientColors: const [
        Colors.purple,
        Colors.pinkAccent,
      ],
      onTap: () => const MistralAIBookSearchRoute().go(context),
    );
  }
}

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({required this.sectionTitle, super.key});

  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      alignment: Alignment.topLeft,
      child: Text(
        sectionTitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 24.2 / 20,
        ),
      ),
    );
  }
}

class HomeExampleTile extends StatelessWidget {
  const HomeExampleTile({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.gradientColors,
    super.key,
  }) : assert(
          gradientColors.length == 2,
          'gradient supports only 2 colors (start and end)',
        );

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: gradientColors,
            stops: const [0.2806, 0.984],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
