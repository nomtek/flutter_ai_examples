part of 'mistralai_chat_page.dart';

const String mistralAIApiKey = String.fromEnvironment('MISTRAL_AI_API_KEY');

final mistralAIClient = MistralAIClient(apiKey: mistralAIApiKey);
