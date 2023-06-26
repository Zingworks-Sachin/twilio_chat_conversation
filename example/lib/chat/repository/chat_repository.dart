import 'package:flutter/services.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/chat_model.dart';

abstract class ChatRepository {
  Future<String> init();
  Future<String> generateToken(credentials);
  Future<String> createConversation(conversationName, identity);
  Future<String> joinConversation(conversationId);
  Future<String> sendMessage(enteredMessage, conversationId, isFromGhatGpt);
  addParticipant(participantName, conversationId);
  Future<List> seeMyConversations();
  Future<List> getMessages(conversationId);
  Future<List<ChatModel>> sendMessageToChatGpt(
      modelsProvider, chatProvider, typeMessage);
  Future<List> getParticipants(String conversationId);
}

class ChatRepositoryImpl implements ChatRepository {
  final platform = const MethodChannel('twilio_chatgpt/twilio_sdk_connection');
  final TwilioChatConversation twilioChatConversationPlugin = TwilioChatConversation();

  //final ApiProvider _apiProvider = ApiProvider();

  @override
  Future<String> createConversation(conversationName, identity) async {
    String response;
    try {
      // final String result = await platform.invokeMethod('createConversation',
      //     {"conversationName": conversationName, "identity": identity});
      final String result = await twilioChatConversationPlugin.createConversation(conversationName:conversationName, identity: identity) ?? "UnImplemented Error";
      //print("createConversation result-->$result");
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<String> generateToken(credentials) async {
    String response;
    try {
      final String result = await twilioChatConversationPlugin.generateToken(accountSid:credentials['accountSid'],apiKey:credentials['apiKey'],apiSecret:credentials['apiSecret'],identity:credentials['identity']) ?? "UnImplemented Error";
      // final String result = await platform.invokeMethod('generateToken', {
      //   "accountSid": credentials['accountSid'],
      //   "apiKey": credentials['apiKey'],
      //   "apiSecret": credentials['apiSecret'],
      //   "identity": credentials['identity']
      // });
      response = result;
      //print("generateToken result-->$response");
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<String> init() async {
    String response;
    try {
      final String result =
          await platform.invokeMethod('init', {"mobileNumber": ""});
      response = result;
    } on PlatformException catch (e) {
      response = e.message.toString();
    }
    return response;
  }

  @override
  Future<String> joinConversation(conversationId) async {
    String response;
    try {
      // final String result = await platform.invokeMethod(
      //     'joinConversation', {"conversationName": conversationName});
      final String result = await twilioChatConversationPlugin.joinConversation(conversationId:conversationId) ?? "UnImplemented Error";
      //print("joinConversation result-->$result");
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<String> sendMessage(
      enteredMessage, conversationId, isFromChatGpt) async {
    String response;
    try {
      // final String result = await platform.invokeMethod('sendMessage', {
      //   "enteredMessage": enteredMessage,
      //   "conversationName": conversationName,
      //   "isFromChatGpt": isFromChatGpt
      // });
      final String result = await twilioChatConversationPlugin.sendMessage(message:enteredMessage,conversationId:conversationId) ?? "UnImplemented Error";
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<String> addParticipant(participantName, conversationId) async {
    String response;
    try {
      // final String result = await platform.invokeMethod('addParticipant', {
      //   "participantName": participantName,
      //   "conversationName": conversationName
      // });
      final String result = await twilioChatConversationPlugin.addParticipant(participantName:participantName,conversationId:conversationId) ?? "UnImplemented Error";
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<List> seeMyConversations() async {
    List response;
    try {
      // final List result = await platform
      //     .invokeMethod('seeMyConversations', {"mobileNumber": ""});
      final List result = await twilioChatConversationPlugin.getConversations() ?? [];
      //print("seeMyConversations->$result");
      // print(result.length.toString());
      response = result;

      return response;
    } on PlatformException catch (e) {
      String message = e.message.toString();
      //response = "Failed to get response";
      return [];
    }
  }

  @override
  Future<List> getMessages(conversationId) async {
    List response = [];
    try {
      // final List result = await platform
      //     .invokeMethod('getMessages', {"conversationName": conversationName});
      final  List result = await twilioChatConversationPlugin.getMessages(conversationId: conversationId) ?? [];
      //print("getMessages result->$result");
      // print(result.length.toString());
      response = result;

      return response;
    } on PlatformException catch (e) {
      String message = e.message.toString();
      //response = "Failed to get response";
      return [];
    }
  }

  @override
  Future<List<ChatModel>> sendMessageToChatGpt(
      modelsProvider, chatProvider, typeMessage) async {
    chatProvider.addUserMessage(msg: typeMessage);
    await chatProvider.sendMessageAndGetAnswers(
        msg: typeMessage, chosenModelId: modelsProvider.getCurrentModel);
    return chatProvider.getChatList;
  }

  @override
  Future<List> getParticipants(String conversationId) async {
    List response = [];
    try {
      final  List result = await twilioChatConversationPlugin.getParticipants(conversationId: conversationId) ?? [];
      //print("getParticipants result->$result");
      response = result;
      return response;
    } on PlatformException catch (e) {
      //print("getParticipants error->$e");
      return [];
    }
  }
}
