import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'twilio_chat_conversation_platform_interface.dart';

/// An implementation of [TwilioChatConversationPlatform] that uses method channels.
class MethodChannelTwilioChatConversation extends TwilioChatConversationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_chat_conversation');

// Define a stream controller for event channel events
  final StreamController<dynamic> _eventStreamController = StreamController<dynamic>.broadcast();

// Expose the event stream to the Flutter app
  Stream<dynamic> get eventStream => _eventStreamController.stream;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Generate token and authenticate user (only for Android) #
  @TargetPlatform.android
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

  /// Create new conversation #
  @override
  Future<String?> createConversation({required String conversationName,required String identity}) async {
    final result = await methodChannel.invokeMethod<String>('createConversation',{
      "conversationName":conversationName,
      "identity":identity
    });
    return result;
  }

  /// Get list of conversations for logged in user #
  @override
  Future<List?> getConversations() async {
    final  List? conversationsList = await methodChannel.invokeMethod('getConversations');
    return conversationsList ?? [];
  }

  /// Get messages from the specific conversation #
  @override
  Future<List?> getMessages({required String conversationId}) async {
    final  List? messages = await methodChannel.invokeMethod('getMessages',{
      "conversationId":conversationId
    });
    //print("messages->$messages");
    return messages ?? [];
  }

  /// Join the existing conversation #
  @override
  Future<String?> joinConversation({required String conversationId}) async {
    final String? result = await methodChannel.invokeMethod<String>('joinConversation',{
      "conversationId":conversationId
    });
    return  result ?? "";
  }

  /// Send message #
  @override
  Future<String?> sendMessage({required String conversationId,required String message}) async {
    final String? result = await methodChannel.invokeMethod<String>('sendMessage',{
      "conversationId":conversationId,
      "message":message
    });
    return  result ?? "";
  }

  /// Add participant in a conversation #
  @override
  Future<String?> addParticipant({required String conversationId,required String participantName}) async {
    final String? result = await methodChannel.invokeMethod<String>('addParticipant',{
      "conversationId":conversationId,
      "participantName":participantName
    });
    return  result ?? "";
  }

  /// Get messages from the specific conversation #
  @override
  Future<String?> receiveMessages({required String conversationId}) async {
    final String? result = await methodChannel.invokeMethod<String>('receiveMessages',{
      "conversationId":conversationId,
    });
    return  result ?? "";
  }

  /// Get participants from the specific conversation #
  @override
  Future<List?> getParticipants({required String conversationId}) async {
    final  List? participantsList = await methodChannel.invokeMethod('getParticipants',{
      "conversationId":conversationId
    });
    return participantsList ?? [];
  }

  // @override
  // Future<Stream> onMessageUpdated({required Map message}) async {
  //   // Set up the event channel listener
  //   _eventChannel.receiveBroadcastStream().listen((event) {
  //     // Add the received event to the stream controller
  //     print("onMessageUpdated->${event.toString()}");
  //     print("onMessageUpdated message->${event.toString()}");
  //     _eventStreamController.add(event);
  //   });
  //   return eventStream;
  // }


@override
  Future<String> subscribeToMessageUpdate({required String conversationId}) async {
    // TODO: implement onMessageUpdated
  //
  final  String? result = await methodChannel.invokeMethod('subscribeToMessageUpdate',{
    "conversationId":conversationId
  });
     return result ?? "";
  }

  @override
  Future<String> unSubscribeToMessageUpdate({required String conversationId}) async {
    // TODO: implement onMessageUpdated
    //
    final  String? result = await methodChannel.invokeMethod('unSubscribeToMessageUpdate',{
      "conversationId":conversationId
    });
    return result ?? "";
  }

  @override
  Future<String?> initializeConversationClient({required String accessToken}) async {
    // TODO: implement initializeConversationClient
    final  String? result = await methodChannel.invokeMethod('initializeConversationClient',{
      "accessToken":accessToken
    });
    return result ?? "";
  }

  @override
  Future<String?> updateAccessToken({required String accessToken}) async {
    // TODO: implement updateAccessToken
    final  String? result = await methodChannel.invokeMethod('updateAccessToken',{
      "accessToken":accessToken
    });
    return result ?? "";
  }
}