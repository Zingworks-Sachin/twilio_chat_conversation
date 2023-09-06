import 'dart:async';
import 'package:flutter/services.dart';
import 'twilio_chat_conversation_platform_interface.dart';

/// A class for managing Twilio Chat conversations and communication.
///
/// This class provides a Flutter interface for interacting with Twilio Chat
/// services. It allows you to manage conversations, send and receive messages,
/// and handle token status changes.
class TwilioChatConversation {
  // Event channels for message updates and token status changes.
  static const EventChannel _messageEventChannel =
      EventChannel('twilio_chat_conversation/onMessageUpdated');
  static const EventChannel _tokenEventChannel =
      EventChannel('twilio_chat_conversation/onTokenStatusChange');

  // Stream controllers for message updates and token status changes.
  static final StreamController<Map> _messageUpdateController =
      StreamController<Map>.broadcast();
  static final StreamController<Map> _tokenStatusController =
      StreamController<Map>.broadcast();

  /// Stream for receiving incoming messages.
  Stream<Map> get onMessageReceived => _messageUpdateController.stream;

  Future<String?> getPlatformVersion() {
    return TwilioChatConversationPlatform.instance.getPlatformVersion();
  }

  /// Generates a Twilio Chat token.
  Future<String?> generateToken(
      {required String accountSid,
      required String apiKey,
      required String apiSecret,
      required String identity,
      required serviceSid}) {
    return TwilioChatConversationPlatform.instance.generateToken(
        accountSid: accountSid,
        apiKey: apiKey,
        apiSecret: apiSecret,
        identity: identity,
        serviceSid: serviceSid);
  }

  /// Initializes the Twilio Conversation Client with an access token.
  ///
  /// This method initializes the Twilio Conversation Client using the provided
  /// access token. Once initialized, the client can be used to interact with
  /// conversations and send/receive messages.
  ///
  /// - [accessToken]: The access token used for authentication.
  ///
  /// Returns a [String] indicating the result of the initialization, or `null` if it fails.
  Future<String?> initializeConversationClient({required String accessToken}) {
    return TwilioChatConversationPlatform.instance
        .initializeConversationClient(accessToken: accessToken);
  }

  /// Creates a new conversation.
  ///
  /// This method creates a new conversation with the specified name and identity.
  ///
  /// - [conversationName]: The name of the new conversation.
  /// - [identity]: The identity of the user initiating the conversation.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> createConversation(
      {required String conversationName, required String identity}) {
    return TwilioChatConversationPlatform.instance.createConversation(
        conversationName: conversationName, identity: identity);
  }

  /// Retrieves a list of conversations.
  ///
  /// This method retrieves a list of conversations available to the user.
  ///
  /// Returns a list of conversations as [List], or `null` if the operation fails.
  Future<List?> getConversations() {
    return TwilioChatConversationPlatform.instance.getConversations();
  }

  /// Retrieves messages from a conversation.
  ///
  /// This method retrieves messages from the specified conversation. The optional
  /// [messageCount] parameter allows you to limit the number of messages to retrieve.
  ///
  /// - [conversationId]: The ID of the conversation from which to retrieve messages.
  /// - [messageCount]: The maximum number of messages to retrieve (optional).
  ///
  /// Returns a list of messages as [List], or `null` if the operation fails.
  Future<List?> getMessages(
      {required String conversationId, int? messageCount}) {
    return TwilioChatConversationPlatform.instance.getMessages(
        conversationId: conversationId, messageCount: messageCount);
  }

  /// Joins a conversation.
  ///
  /// This method allows a user to join an existing conversation by specifying its ID.
  ///
  /// - [conversationId]: The ID of the conversation to join.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> joinConversation({required String conversationId}) {
    return TwilioChatConversationPlatform.instance
        .joinConversation(conversationId: conversationId);
  }

  /// Sends a message in a conversation.
  ///
  /// This method sends a message in the specified conversation.
  ///
  /// - [message]: The message content to send.
  /// - [conversationId]: The ID of the conversation in which to send the message.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> sendMessage({required message, required conversationId}) {
    return TwilioChatConversationPlatform.instance
        .sendMessage(conversationId: conversationId, message: message);
  }

  /// Adds a participant in a conversation.
  ///
  /// - [participantName]: The name of the participant to be added.
  /// - [conversationId]: The ID of the conversation in which to add the participant.
  Future<String?> addParticipant(
      {required participantName, required conversationId}) {
    return TwilioChatConversationPlatform.instance.addParticipant(
        conversationId: conversationId, participantName: participantName);
  }

  /// Removes a participant from a conversation.
  ///
  /// - [participantName]: The name of the participant to be removed.
  /// - [conversationId]: The ID of the conversation from which to remove the participant.
  Future<String?> removeParticipant(
      {required participantName, required conversationId}) {
    return TwilioChatConversationPlatform.instance.removeParticipant(
        conversationId: conversationId, participantName: participantName);
  }

  /// Receives messages for a specific conversation.
  ///
  /// - [conversationId]: The ID of the conversation for which to receive messages.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> receiveMessages({required String conversationId}) {
    return TwilioChatConversationPlatform.instance
        .receiveMessages(conversationId: conversationId);
  }

  /// Retrieves a list of participants for a conversation.
  ///
  /// - [conversationId]: The ID of the conversation for which to retrieve participants.
  ///
  /// Returns a list of participants as [List], or `null` if the operation fails.
  Future<List?> getParticipants({required String conversationId}) {
    return TwilioChatConversationPlatform.instance
        .getParticipants(conversationId: conversationId);
  }

  /// Subscribes to message update events for a specific conversation.
  void subscribeToMessageUpdate({required String conversationSid}) async {
    TwilioChatConversationPlatform.instance
        .subscribeToMessageUpdate(conversationId: conversationSid);
    _messageEventChannel
        .receiveBroadcastStream(conversationSid)
        .listen((dynamic message) {
      if (message != null) {
        if (message["author"] != null && message["body"] != null) {
          _messageUpdateController.add(message);
        }
      }
    });
  }

  /// Unsubscribes from message update events for a specific conversation.
  void unSubscribeToMessageUpdate({required String conversationSid}) {
    TwilioChatConversationPlatform.instance
        .unSubscribeToMessageUpdate(conversationId: conversationSid);
  }

  /// Updates the access token used for communication.
  Future<Map?> updateAccessToken({required String accessToken}) {
    return TwilioChatConversationPlatform.instance
        .updateAccessToken(accessToken: accessToken);
  }

  /// Stream for receiving token status changes.
  Stream<Map> get onTokenStatusChange {
    _tokenEventChannel.receiveBroadcastStream().listen((dynamic tokenStatus) {
      _tokenStatusController.add(tokenStatus);
    });
    return _tokenStatusController.stream;
  }
}
