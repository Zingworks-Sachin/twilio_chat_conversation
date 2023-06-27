import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'twilio_chat_conversation_platform_interface.dart';

/// An implementation of [TwilioChatConversationPlatform] that uses method channels.
class MethodChannelTwilioChatConversation extends TwilioChatConversationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_chat_conversation');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> generateToken({required String accountSid, required String apiKey, required String apiSecret, required String identity,required String serviceSid}) async {
    final accessToken = await methodChannel.invokeMethod<String>('generateToken',{
      "accountSid": accountSid,
      "apiKey": apiKey,
      "apiSecret": apiSecret,
      "identity": identity,
      "serviceSid":serviceSid
    });
    return accessToken;
  }

  @override
  Future<String?> createConversation({required String conversationName,required String identity}) async {
    final result = await methodChannel.invokeMethod<String>('createConversation',{
      "conversationName":conversationName,
      "identity":identity
    });
    return result;
  }

  @override
  Future<List?> getConversations() async {
    final  List? conversationsList = await methodChannel.invokeMethod('getConversations');
    return conversationsList ?? [];
  }

  @override
  Future<List?> getMessages({required String conversationId}) async {
    final  List? messages = await methodChannel.invokeMethod('getMessages',{
      "conversationId":conversationId
    });
    //print("messages->$messages");
    return messages ?? [];
  }

  @override
  Future<String?> joinConversation({required String conversationId}) async {
    final String? result = await methodChannel.invokeMethod<String>('joinConversation',{
      "conversationId":conversationId
    });
    return  result ?? "";
  }
  @override
  Future<String?> sendMessage({required String conversationId,required String message}) async {
    final String? result = await methodChannel.invokeMethod<String>('sendMessage',{
      "conversationId":conversationId,
      "message":message
    });
    return  result ?? "";
  }

  @override
  Future<String?> addParticipant({required String conversationId,required String participantName}) async {
    final String? result = await methodChannel.invokeMethod<String>('addParticipant',{
      "conversationId":conversationId,
      "participantName":participantName
    });
    return  result ?? "";
  }

  @override
  Future<String?> receiveMessages({required String conversationId}) async {
    final String? result = await methodChannel.invokeMethod<String>('receiveMessages',{
      "conversationId":conversationId,
    });
    return  result ?? "";
  }
  @override
  Future<List?> getParticipants({required String conversationId}) async {
    final  List? participantsList = await methodChannel.invokeMethod('getParticipants',{
      "conversationId":conversationId
    });
    return participantsList ?? [];
  }

}