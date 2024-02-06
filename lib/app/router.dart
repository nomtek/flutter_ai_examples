import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mistral_ai_chat_example_app/app/app_settings/app_settings_page.dart';
import 'package:mistral_ai_chat_example_app/app/home_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/mistralai_book_search_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/mistralai_chat_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_llm_controller_example/mistral_ai_llm_controller_page.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_summary_example/mistralai_summary_page.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<AppSettingsRoute>(path: 'app-settings'),
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

class AppSettingsRoute extends GoRouteData {
  const AppSettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildPage(const AppSettingsPage());
  }
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
    return _buildPage(const MistralAISummaryPage());
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
