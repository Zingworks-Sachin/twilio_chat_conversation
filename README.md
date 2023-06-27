[![pub package](https://img.shields.io/pub/v/twilio_chat_conversation.svg)](https://pub.dartlang.org/packages/twilio_chat_conversation)

<br>
<p align="center">
<img alt="twilio_chat_conversation" src="https://github.com/Zingworks-Sachin/twilio_chat_conversation/blob/main/assets/images/twilio%2Bflutter.png?raw=true" />
</p>
<br><br>

# Introduction

A Flutter plugin for [Twilio Conversations](https://www.twilio.com/docs/conversations) which allows you to build engaging conversational messaging experiences for Android and iOS.
Currently this plugin only supports Android platform.

This package is currently in development phase and should not be used for production apps.

## Supported platforms
- Android
- iOS (in progress)

## Example
Check out the [example](https://github.com/Zingworks-Sachin/twilio_chat_conversation.git)

## Usage
### Obtain an instance
```dart
final TwilioChatConversation twilioChatConversationPlugin = TwilioChatConversation();
```

### Generate token and authenticate user
```dart
final String? result = await twilioChatConversationPlugin.generateToken(accountSid:credentials['accountSid'],apiKey:credentials['apiKey'],apiSecret:credentials['apiSecret'],identity:credentials['identity'],serviceSid: credentials['serviceSid']);
```

### Create new conversation
```dart
final String? result = await twilioChatConversationPlugin.createConversation(conversationName:conversationName, identity: identity);
```

### Get list of conversations for logged in user
```dart
final List result = await twilioChatConversationPlugin.getConversations() ?? [];
```

### Get messages from the specific conversation
```dart
final  List result = await twilioChatConversationPlugin.getMessages(conversationId: conversationId) ?? [];
```

### Join the existing conversation
```dart
final String? result = await twilioChatConversationPlugin.joinConversation(conversationId:conversationId);
```

### Send message
```dart
final String? result = await twilioChatConversationPlugin.sendMessage(message:enteredMessage,conversationId:conversationId);
```

### Add participant in a conversation
```dart
final String? result = await twilioChatConversationPlugin.addParticipant(participantName:participantName,conversationId:conversationId);
```

### Get participants from the specific conversation
```dart
final  List result = await twilioChatConversationPlugin.getParticipants(conversationId: conversationId) ?? [];
```

## License
[MIT License](https://github.com/Zingworks-Sachin/twilio_chat_conversation/blob/main/LICENSE)

## Issues and feedback
If you have any suggestions for including a feature or if something doesn't work, feel free to open a Github [issue](https://github.com/Zingworks-Sachin/twilio_chat_conversation/issues) or to open a [pull request](https://github.com/Zingworks-Sachin/twilio_chat_conversation/pulls), you are more than welcome to contribute!

## Contributor
- Sachin Pandit ([ZingWorks LLP](https://zingworks.in/))
