import 'package:flutter_test/flutter_test.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation_platform_interface.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTwilioChatConversationPlatform
    with MockPlatformInterfaceMixin
    implements TwilioChatConversationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> createConversation(
      {required String conversationName, required String identity}) {
    // TODO: implement createConversation
    throw UnimplementedError();
  }

  @override
  Future<String?> generateToken(
      {required String accountSid,
      required String apiKey,
      required String apiSecret,
      required String identity,
      required String serviceSid}) {
    // TODO: implement generateToken
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, Object>>> getConversations() {
    // TODO: implement getConversations
    throw UnimplementedError();
  }

  @override
  Future<List?> getMessages(
      {required String conversationId, int? messageCount}) {
    // TODO: implement getMessagesFromConversation
    throw UnimplementedError();
  }

  @override
  Future<String?> joinConversation({required conversationId}) {
    // TODO: implement joinConversation
    throw UnimplementedError();
  }

  @override
  Future<String?> sendMessage(
      {required String conversationId, required String message}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<String?> addParticipant(
      {required String conversationId, required String participantName}) {
    // TODO: implement addParticipant
    throw UnimplementedError();
  }

  @override
  Future<String?> receiveMessages({required String conversationId}) {
    // TODO: implement receiveMessages
    throw UnimplementedError();
  }

  @override
  Future<List?> getParticipants({required String conversationId}) {
    // TODO: implement getParticipants
    throw UnimplementedError();
  }

  @override
  Future<String?> subscribeToMessageUpdate({required String conversationId}) {
    // TODO: implement subscribeToMessageUpdate
    throw UnimplementedError();
  }

  @override
  Future<String?> unSubscribeToMessageUpdate({required String conversationId}) {
    // TODO: implement unSubscribeToMessageUpdate
    throw UnimplementedError();
  }

  @override
  Future<String?> initializeConversationClient({required String accessToken}) {
    // TODO: implement initializeConversationClient
    throw UnimplementedError();
  }

  @override
  Future<Map?> updateAccessToken({required String accessToken}) {
    // TODO: implement updateAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> removeParticipant(
      {required conversationId, required participantName}) {
    // TODO: implement removeParticipant
    throw UnimplementedError();
  }
}

void main() {
  final TwilioChatConversationPlatform initialPlatform =
      TwilioChatConversationPlatform.instance;

  test('$MethodChannelTwilioChatConversation is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelTwilioChatConversation>());
  });

  test('getPlatformVersion', () async {
    TwilioChatConversation twilioChatConversationPlugin =
        TwilioChatConversation();
    MockTwilioChatConversationPlatform fakePlatform =
        MockTwilioChatConversationPlatform();
    TwilioChatConversationPlatform.instance = fakePlatform;
    expect(await twilioChatConversationPlugin.getPlatformVersion(), '42');
  });
}
