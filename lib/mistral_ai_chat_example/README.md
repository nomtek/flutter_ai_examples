# Mistral AI Chat example

This is an example of AI chat similar to OpenAI's ChatGPT but using Mistral AI model.

Example is using [mistralai_client_dart](https://pub.dev/packages/mistralai_client_dart) to access Mistral model using REST API.

<https://github.com/nomtek/flutter_ai_examples/assets/2642942/d349d8e3-15bf-4773-86ff-77b333630588>

## Features

1. Remembers the chat history
2. Option to change between streaming and full response mode

## How to open example

Follow instruction on how to run example app from [projects README.md](../../README.md).
When app is running go to `MistralAI Chat example` page.

## How it works?

Using `MistralAIClient` we request chat responses from API.

The API takes a list of messages with a role for each message.

User messages have a role of `user` and chat responses have `assistant` role.

So for AI to have a context of the chat we are keeping the history of the chat (all messages) in memory and send it back to AI with new user message each time.

For example:

This is what will be send when user sends first message.

```dart
final params = ChatParams(
    model: 'mistral-small',
    messages: [
        ChatMessage(role: 'user', content: 'Hi chat!'),
    ],
);
mistralAIClient.chat(params);
```

Then we get a response like (omitting the exact code and model for chat response):

```text
Hey how can I help you today?
```

So next time user sends a message we will send now a chat like this:

```dart
final params = ChatParams(
    model: 'mistral-small',
    messages: [
        ChatMessage(role: 'user', content: 'Hi chat!'),
        ChatMessage(role: 'assistant', content: 'Hey how can I help you today?'),
        ChatMessage(role: 'user', content: 'Can you help me write an Flutter example app about AI using Mistral API?'),
    ],
);
mistralAIClient.chat(params);
```

Basically every time we are doing back and forth with response and answer send back to the API. The whole conversation context is kept. This is required to be able for AI to answer question about previous questions or answers that happened during chat.

## Room for improvements

The example is a simple example and showcase how chat can be built. There are few things that can be improved to make it more real world.

1. Make sure that maximum count of tokens in a chat is not exceeded. Mistral can process max 32k tokens at a time so the longer the history is then we are closer and closer to this limit. There are few strategies to do that:
   - To save space we could generate a summary of the older messages in chat and use this as context instead of sending the exact chat history.
   - We could send only last X messages instead of the whole conversation
   - Mix of above
2. Save chat history to database instead of keeping it in memory
3. Try to cache answers and maybe reuse (answer with cached response to the same question) them to lower the cost of API usage.
