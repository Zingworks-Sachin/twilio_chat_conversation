import 'dart:async';
import 'package:flutter/services.dart';
import 'twilio_chat_conversation_platform_interface.dart';

class TwilioChatConversation {

  static const EventChannel _eventChannel = EventChannel('twilio_chat_conversation/onMessageUpdated');
  static final StreamController<Map> _messageUpdateController = StreamController<Map>.broadcast();

  Stream<Map> get onMessageReceived => _messageUpdateController.stream;

  Future<String?> getPlatformVersion() {
    return TwilioChatConversationPlatform.instance.getPlatformVersion();
  }

  Future<String?> generateToken({required String accountSid, required String apiKey, required String apiSecret, required String identity, required serviceSid}) {
    return TwilioChatConversationPlatform.instance.generateToken(accountSid: accountSid,apiKey:apiKey,apiSecret:apiSecret,identity:identity,serviceSid:serviceSid);
  }

  Future<String?> createConversation({required String conversationName,required String identity}) {
    return TwilioChatConversationPlatform.instance.createConversation(conversationName: conversationName, identity:identity);
  }

  Future<List?> getConversations() {
    return TwilioChatConversationPlatform.instance.getConversations();
  }

  Future<List?> getMessages({required String conversationId}) {
    return TwilioChatConversationPlatform.instance.getMessages(conversationId:conversationId);
  }

  Future<String?> joinConversation({required String conversationId}) {
    return TwilioChatConversationPlatform.instance.joinConversation(conversationId: conversationId);
  }

  Future<String?> sendMessage({required message, required conversationId}) {
    return TwilioChatConversationPlatform.instance.sendMessage(conversationId: conversationId,message: message);
  }

  Future<String?> addParticipant({required participantName, required conversationId}) {
    return TwilioChatConversationPlatform.instance.addParticipant(conversationId: conversationId,participantName:participantName);
  }

  Future<String?> receiveMessages({required String conversationId}) {
    return TwilioChatConversationPlatform.instance.receiveMessages(conversationId: conversationId);
  }

  Future<List?> getParticipants({required String conversationId}) {
    return TwilioChatConversationPlatform.instance.getParticipants(conversationId: conversationId);
  }

  void subscribeToMessageUpdate({required String conversationSid}) async  {
     TwilioChatConversationPlatform.instance.subscribeToMessageUpdate(conversationId: conversationSid);
     _eventChannel.receiveBroadcastStream(conversationSid).listen((dynamic batteryLevel) {
       _messageUpdateController.add(batteryLevel);
     });
  }

  void unSubscribeToMessageUpdate({required String conversationSid}) {
     TwilioChatConversationPlatform.instance.unSubscribeToMessageUpdate(conversationId: conversationSid);
     // _messageUpdateController.close();
     // _messageUpdateController = StreamController<Map>();
  }
}
