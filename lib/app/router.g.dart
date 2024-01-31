// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'mistralai-chat',
          factory: $MistralAIChatRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'mistralai-summary',
          factory: $MistralAISummaryRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'mistralai-llm-controller',
          factory: $MistralAILlmControllerRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MistralAIChatRouteExtension on MistralAIChatRoute {
  static MistralAIChatRoute _fromState(GoRouterState state) =>
      const MistralAIChatRoute();

  String get location => GoRouteData.$location(
        '/mistralai-chat',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MistralAISummaryRouteExtension on MistralAISummaryRoute {
  static MistralAISummaryRoute _fromState(GoRouterState state) =>
      const MistralAISummaryRoute();

  String get location => GoRouteData.$location(
        '/mistralai-summary',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MistralAILlmControllerRouteExtension on MistralAILlmControllerRoute {
  static MistralAILlmControllerRoute _fromState(GoRouterState state) =>
      const MistralAILlmControllerRoute();

  String get location => GoRouteData.$location(
        '/mistralai-llm-controller',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
