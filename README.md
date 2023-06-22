<br>
<p align="center">
<img alt="FlutterBlue" src="https://github.com/Zingworks-Sachin/twilio_chat_conversation/blob/main/assets/images/twilio_logo_red.svg?raw=true" />
</p>
<br><br>

# Introduction

A Flutter plugin for [Twilio Conversations](https://www.twilio.com/docs/conversations) which allows you to build engaging conversational messaging experiences for Android and iOS. 

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
final String? result = await twilioChatConversationPlugin.generateToken(accountSid:credentials['accountSid'],apiKey:credentials['apiKey'],apiSecret:credentials['apiSecret'],identity:credentials['identity']);
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

### Get messages
```dart
final  List result = await twilioChatConversationPlugin.getMessages(conversationId: conversationId) ?? [];
```
### Add participant in a conversation
```dart
final String? result = await twilioChatConversationPlugin.addParticipant(participantName:participantName,conversationId:conversationId);
```

Developed By
- Sachin Pandit
[ZingWorks LLP](https://zingworks.in/)