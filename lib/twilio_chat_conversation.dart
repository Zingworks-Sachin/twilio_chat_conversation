
import 'twilio_chat_conversation_platform_interface.dart';

class TwilioChatConversation {
  Future<String?> getPlatformVersion() {
    return TwilioChatConversationPlatform.instance.getPlatformVersion();
  }

  Future<String?> generateToken({required String accountSid, required String apiKey, required String apiSecret, required String identity}) {
    return TwilioChatConversationPlatform.instance.generateToken(accountSid: accountSid,apiKey:apiKey,apiSecret:apiSecret,identity:identity);
  }

  Future<String?> createConversation({required String conversationName,required String identity}) {
    return TwilioChatConversationPlatform.instance.createConversation(conversationName: conversationName, identity:identity);
  }

  Future<List?> getConversations() {
    return TwilioChatConversationPlatform.instance.getConversations();
  }

  Future<List?> getMessagesFromConversation({required String conversationId}) {
    return TwilioChatConversationPlatform.instance.getMessagesFromConversation(conversationId:conversationId);
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

}
