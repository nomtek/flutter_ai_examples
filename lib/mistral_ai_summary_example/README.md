# Mistral AI Summary Example

This example showcase how to use [mistral_ai_client_dart](https://pub.dev/packages/mistralai_client_dart) summarize text.

## Features

- Summarize example text
- Summarize custom text
- Change summary settings

## Demo

[![Demo](../../docs/assets/text_summary_example_demo.gif)](../../docs/assets/text_summary_example_demo.gif)

## Prompt and AI chat construction

The usage of the Mistral AI API is very simple. It is just one message from the user and the AI will respond with the summary.

```dart
final response = await mistralAIClient.chat(
        ChatParams(
          model: 'mistral-small',
          messages: [
            ChatMessage(role: 'user', content: text),
          ],
        ),
      );
```

The text that is sent to the AI is a little bit more complex. The text that is going to be summarized is wrapped in a prompt that tells the AI what to do.

```dart
String getSummaryPromptForText(String text) {
  return '''
###
$text
###
Please provide a concise summary of the text:
- Highlight the most important entities.
- Should contain 4-5 sentences.
      
Guidelines for generating summaries:
- Each sentence should be:
- Relevant to the main story.
- Avoid repetitive and uninformative phrases.
- Truly present in the article.
- Summaries should be easily understood without referencing the article.
''';
}
```

Let's break it down:

```text
Please provide a concise summary of the text:
- Highlight the most important entities.
- Should contain 4-5 sentences.      
```

It is important to specify what the AI should do. Especially in terms of the length of the summary from our experience, it tends to be a little bit too long

```text
Guidelines for generating summaries, each sentence should be:
- Relevant to the main story.
- Avoid repetitive and uninformative phrases.
- Truly present in the article.
- Summaries should be easily understood without referencing the article.
```

Those are more detailed instructions for the AI. Telling it may help the AI to generate a better summary with fewer hallucinations.

## Problems and difficulties

Despite detailed instructions, the AI sometimes generates summaries that are too long specialty for the small models. Possible solution is to improve the prompt and the instructions for the AI.
