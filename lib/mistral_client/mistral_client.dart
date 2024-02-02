import 'package:mistralai_client_dart/mistralai_client_dart.dart';

const String mistralAIApiKey = String.fromEnvironment('MISTRAL_AI_API_KEY');

// MistralAI client instance to use in app
// across multiple examples
final mistralAIClient = MistralAIClient(apiKey: mistralAIApiKey);
