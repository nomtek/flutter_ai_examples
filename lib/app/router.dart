import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mistral_ai_chat_example_app/app/home_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/mistralai_book_search_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/mistralai_chat_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/mistral_ai_llm_controller_page.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<MistralAIChatRoute>(path: 'mistralai-chat'),
    TypedGoRoute<MistralAISummaryRoute>(path: 'mistralai-summary'),
    TypedGoRoute<MistralAILlmControllerRoute>(path: 'mistralai-llm-controller'),
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
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildPage(const MistralAIChatPage());
  }
}

class MistralAISummaryRoute extends GoRouteData {
  const MistralAISummaryRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildPage(const MistralAIBookSearchPage());
  }
}

class MistralAILlmControllerRoute extends GoRouteData {
  const MistralAILlmControllerRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildPage(const MistralAILlmControllerPage());
  }
}

class MistralAIBookSearchRoute extends GoRouteData {
  const MistralAIBookSearchRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildPage(const MistralAIBookSearchPage());
  }
}

// builds page with no transition for web and material page for other platforms
Page<void> _buildPage(Widget child) {
  if (kIsWeb) {
    return NoTransitionPage<void>(child: child);
  }
  return MaterialPage(child: child);
}
