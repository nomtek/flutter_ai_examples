import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mistral_ai_chat_example_app/page/home_page.dart';
import 'package:mistral_ai_chat_example_app/page/mistralai_chat_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) => GoRouter(routes: $appRoutes);

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<MistralAIChatRoute>(path: 'mistralai-chat'),
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
