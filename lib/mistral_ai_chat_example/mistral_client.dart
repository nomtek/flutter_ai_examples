import 'package:mistralai_client_dart/mistralai_client_dart.dart';

const String mistralAIApiKey = String.fromEnvironment('MISTRAL_AI_API_KEY');

final mistralAIClient = MistralAIClient(apiKey: mistralAIApiKey);
