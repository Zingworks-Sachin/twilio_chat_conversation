import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'twilio_chat_conversation_method_channel.dart';

abstract class TwilioChatConversationPlatform extends PlatformInterface {
  /// Constructs a TwilioChatConversationPlatform.
  TwilioChatConversationPlatform() : super(token: _token);

  static final Object _token = Object();

  static TwilioChatConversationPlatform _instance =
      MethodChannelTwilioChatConversation();

  /// The default instance of [TwilioChatConversationPlatform] to use.
  ///
  /// Defaults to [MethodChannelTwilioChatConversation].
  static TwilioChatConversationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TwilioChatConversationPlatform] when
  /// they register themselves.
  static set instance(TwilioChatConversationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> generateToken(
      {required String accountSid,
      required String apiKey,
      required String apiSecret,
      required String identity,
      required String serviceSid}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> createConversation(
      {required String conversationName, required String identity}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List?> getConversations() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List?> getMessages(
      {required String conversationId, int? messageCount}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> joinConversation({required String conversationId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> sendMessage(
      {required String conversationId, required String message}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> addParticipant(
      {required String conversationId, required String participantName}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> receiveMessages({required String conversationId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List?> getParticipants({required String conversationId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> subscribeToMessageUpdate({required String conversationId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> unSubscribeToMessageUpdate({required String conversationId}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initializeConversationClient({required String accessToken}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map?> updateAccessToken({required String accessToken}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> removeParticipant(
      {required conversationId, required participantName}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
