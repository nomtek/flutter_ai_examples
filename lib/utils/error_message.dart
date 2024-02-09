import 'package:mistralai_client_dart/mistralai_client_dart.dart';

String getNiceErrorMessage(dynamic error) {
  final errorText = error.toString();
  if (error is MistralAIClientException) {
    final isUnauthorized = errorText.contains('401');
    return isUnauthorized
        ? 'Unauthorized. Please check your API key.'
        : 'Something went wrong when sending a request to Mistral API. '
            'Please try again.\n($errorText)';
  }
  return 'Something went wrong. Please try again.\n($errorText)';
}
