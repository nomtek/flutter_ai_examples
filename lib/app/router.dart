import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mistral_ai_chat_example_app/app/home_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/mistralai_book_search_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/mistralai_chat_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/mistralai_summary_page.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<MistralAIChatRoute>(path: 'mistralai-chat'),
    TypedGoRoute<MistralAISummaryRoute>(path: 'mistralai-summary'),
    TypedGoRoute<MistralAIBookSearchRoute>(path: 'mistralai-book-search'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class MistralAIChatRoute extends GoRouteData {
  const MistralAIChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MistralAIChatPage();
}

class MistralAISummaryRoute extends GoRouteData {
  const MistralAISummaryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MistralAISummaryPage();
}

class MistralAIBookSearchRoute extends GoRouteData {
  const MistralAIBookSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MistralAIBookSearchPage();
}
