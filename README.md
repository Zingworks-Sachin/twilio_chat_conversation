[![pub package](https://img.shields.io/pub/v/twilio_chat_conversation.svg)](https://pub.dartlang.org/packages/twilio_chat_conversation)

<br>
<p align="center">
<img alt="twilio_chat_conversation" src="https://github.com/Zingworks-Sachin/twilio_chat_conversation/blob/main/assets/images/twilio%2Bflutter.png?raw=true" />
</p>
<br><br>

# Introduction

A Flutter plugin for [Twilio Conversations](https://www.twilio.com/docs/conversations) which allows you to build engaging conversational messaging experiences for Android and iOS.

## Supported platforms
- Android
- iOS

## Features
- Generate Twilio Access Token(Only Android)
- Create new conversation
- Get list of conversations
- Fetch list of messages in the conversation
- Join an existing conversation
- Send Messages
- Listen to message update whenever new message is received
- Add participants in the conversation
- Remove participants from the conversation
- Get list of participants from the specific conversation
- Listen to access token expiration

## Example
Check out the [example](https://github.com/Zingworks-Sachin/twilio_chat_conversation.git)

## Usage
### Obtain an instance
```dart
final TwilioChatConversation twilioChatConversationPlugin = TwilioChatConversation();
```

### Generate token (Only Android)
```dart
// Use the Twilio helper libraries in your back end web services to create access tokens for both Android and iOS platform. However you can use this method to generate access token for Android.
final String? result = await twilioChatConversationPlugin.generateToken(accountSid:credentials['accountSid'],apiKey:credentials['apiKey'],apiSecret:credentials['apiSecret'],identity:credentials['identity'],serviceSid: credentials['serviceSid']);
```

### Initialize conversation client with the access token
```dart
/// Once you receive the access token from your back end web services, pass it to this method to authenticate the twilio user
final String result = await twilioChatConversationPlugin.initializeConversationClient(accessToken: accessToken);
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

### Join an existing conversation
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
### Remove participant from a conversation
```dart
final String? result = await twilioChatConversationPlugin.removeParticipant(participantName:participantName,conversationId:conversationId);
```

### Get participants from the specific conversation
```dart
final  List result = await twilioChatConversationPlugin.getParticipants(conversationId: conversationId) ?? [];
```

### Subscribe to message update
```dart
/// Use this method to listen to newly added messages in a conversation
twilioChatConversationPlugin.subscribeToMessageUpdate(conversationSid:widget.conversationSid);
twilioChatConversationPlugin.onMessageReceived.listen((event) {
});
```

### Unsubscribe to message update
```dart
/// Use this method to receive newly added messages in a conversation
twilioChatConversationPlugin.unSubscribeToMessageUpdate(conversationSid: widget.conversationSid);
```

### Listen to access token expiration
```dart
twilioChatConversationPlugin.onTokenStatusChange.listen((tokenData) {
if (tokenData["statusCode"] == 401){
     generateAndUpdateAccessToken()
   }
});
```
### Update access token
```dart
/// Call this method if your access token is expired or is about to expire.
/// Regenerate the access token in your backend and use this method to update the token.
final Map? result = await twilioChatConversationPlugin.updateAccessToken(accessToken:accessToken);
```

## License
[MIT License](https://github.com/Zingworks-Sachin/twilio_chat_conversation/blob/main/LICENSE)

## Issues and feedback
If you have any suggestions for including a feature or if something doesn't work, feel free to open a Github [issue](https://github.com/Zingworks-Sachin/twilio_chat_conversation/issues) or to open a [pull request](https://github.com/Zingworks-Sachin/twilio_chat_conversation/pulls), you are more than welcome to contribute!

## Contributor
- Sachin Pandit ([ZingWorks LLP](https://zingworks.in/))
