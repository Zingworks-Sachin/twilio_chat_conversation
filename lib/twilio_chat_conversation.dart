import 'dart:async';
import 'package:flutter/services.dart';
import 'twilio_chat_conversation_platform_interface.dart';

class TwilioChatConversation {

  static const EventChannel _messageEventChannel = EventChannel('twilio_chat_conversation/onMessageUpdated');
  static const EventChannel _tokenEventChannel = EventChannel('twilio_chat_conversation/onTokenStatusChange');
  static final StreamController<Map> _messageUpdateController = StreamController<Map>.broadcast();
  static final StreamController<Map> _tokenStatusController = StreamController<Map>.broadcast();
  Stream<Map> get onMessageReceived => _messageUpdateController.stream;

  Future<String?> getPlatformVersion() {
    return TwilioChatConversationPlatform.instance.getPlatformVersion();
  }

  Future<String?> generateToken({required String accountSid, required String apiKey, required String apiSecret, required String identity, required serviceSid}) {
    return TwilioChatConversationPlatform.instance.generateToken(accountSid: accountSid,apiKey:apiKey,apiSecret:apiSecret,identity:identity,serviceSid:serviceSid);
  }

  Future<String?> initializeConversationClient({required String accessToken}) {
    return TwilioChatConversationPlatform.instance.initializeConversationClient(accessToken: accessToken);
  }

  Future<String?> createConversation({required String conversationName,required String identity}) {
    return TwilioChatConversationPlatform.instance.createConversation(conversationName: conversationName, identity:identity);
  }

  Future<List?> getConversations() {
    return TwilioChatConversationPlatform.instance.getConversations();
  }

  Future<List?> getMessages({required String conversationId,int? messageCount}) {
    return TwilioChatConversationPlatform.instance.getMessages(conversationId:conversationId,messageCount:messageCount);
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
     _messageEventChannel.receiveBroadcastStream(conversationSid).listen((dynamic message) {
       if (message != null){
         if (message["author"] != null && message["body"] != null){
           _messageUpdateController.add(message);
         }
       }
     });
  }

  void unSubscribeToMessageUpdate ({required String conversationSid}) {
     TwilioChatConversationPlatform.instance.unSubscribeToMessageUpdate(conversationId: conversationSid);
  }

  Future<Map?> updateAccessToken ({required String accessToken}) {
   return TwilioChatConversationPlatform.instance.updateAccessToken(accessToken: accessToken);
  }


  Stream<Map> get onTokenStatusChange {
    _tokenEventChannel.receiveBroadcastStream().listen((dynamic tokenStatus) {
      _tokenStatusController.add(tokenStatus);
    });
    return _tokenStatusController.stream;
  }
}