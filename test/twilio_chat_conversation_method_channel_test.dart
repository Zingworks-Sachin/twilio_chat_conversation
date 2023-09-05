import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation_method_channel.dart';

void main() {
  MethodChannelTwilioChatConversation platform =
      MethodChannelTwilioChatConversation();
  const MethodChannel channel = MethodChannel('twilio_chat_conversation');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
