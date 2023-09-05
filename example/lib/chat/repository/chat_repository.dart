import 'dart:io';
import 'package:flutter/services.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_chat_conversation_example/chat/common/api/api_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/chat_model.dart';

abstract class ChatRepository {
  Future<String> initializeConversationClient(String accessToken);
  Future<String> generateToken(credentials);
  Future<Map> updateAccessToken(String accessToken);
  Future<String> getAccessTokenFromServer(credentials);
  Future<String> createConversation(conversationName, identity);
  Future<String> joinConversation(conversationId);
  Future<String> sendMessage(enteredMessage, conversationId, isFromGhatGpt);
  addParticipant(participantName, conversationId);
  removeParticipant(participantName, conversationId);
  Future<List> seeMyConversations();
  Future<List> getMessages(conversationId, int? messageCount);
  Future<List<ChatModel>> sendMessageToChatGpt(
      modelsProvider, chatProvider, typeMessage);
  Future<List> getParticipants(String conversationId);
}

class ChatRepositoryImpl implements ChatRepository {
  final platform = const MethodChannel('twilio_chatgpt/twilio_sdk_connection');
  final TwilioChatConversation twilioChatConversationPlugin =
      TwilioChatConversation();
  final _apiProvider = ApiProvider();

  @override
  Future<String> createConversation(conversationName, identity) async {
    String response;
    try {
      final String result =
          await twilioChatConversationPlugin.createConversation(
                  conversationName: conversationName, identity: identity) ??
              "UnImplemented Error";
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
      String result = "";
      if (Platform.isAndroid) {
        result = await twilioChatConversationPlugin.generateToken(
                accountSid: credentials['accountSid'],
                apiKey: credentials['apiKey'],
                apiSecret: credentials['apiSecret'],
                identity: credentials['identity'],
                serviceSid: credentials['serviceSid']) ??
            "UnImplemented Error";
      } else {}
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }

  @override
  Future<String> initializeConversationClient(String accessToken) async {
    String response;
    try {
      final String result = await twilioChatConversationPlugin
              .initializeConversationClient(accessToken: accessToken) ??
          "UnImplemented Error";
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
      final String result = await twilioChatConversationPlugin.joinConversation(
              conversationId: conversationId) ??
          "UnImplemented Error";
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
      final String result = await twilioChatConversationPlugin.sendMessage(
              message: enteredMessage, conversationId: conversationId) ??
          "UnImplemented Error";
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
      final String result = await twilioChatConversationPlugin.addParticipant(
              participantName: participantName,
              conversationId: conversationId) ??
          "UnImplemented Error";
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
      final List result =
          await twilioChatConversationPlugin.getConversations() ?? [];
      response = result;

      return response;
    } on PlatformException catch (_) {
      return [];
    }
  }

  @override
  Future<List> getMessages(conversationId, messageCount) async {
    List response = [];
    try {
      final List result = await twilioChatConversationPlugin.getMessages(
              conversationId: conversationId, messageCount: messageCount) ??
          [];
      response = result;

      return response;
    } on PlatformException catch (_) {
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
      final List result = await twilioChatConversationPlugin.getParticipants(
              conversationId: conversationId) ??
          [];
      //print("getParticipants result->$result");
      response = result;
      return response;
    } on PlatformException catch (e) {
      //print("getParticipants error->$e");
      return [];
    }
  }

  @override
  Future<String> getAccessTokenFromServer(credentials) async {
    Map<String, dynamic> response =
        await _apiProvider.get(credentials["identity"]);
    if (response["statusCode"] == 200) {
      return response["token"];
    } else {
      return response[""];
    }
  }

  @override
  Future<Map> updateAccessToken(String accessToken) async {
    Map? response;
    try {
      final Map? result = await twilioChatConversationPlugin.updateAccessToken(
          accessToken: accessToken);
      response = result;
    } on PlatformException catch (e) {
      response = {};
    }
    return response ?? {};
  }

  @override
  removeParticipant(participantName, conversationId) async {
    String response;
    try {
      final String result =
          await twilioChatConversationPlugin.removeParticipant(
                  participantName: participantName,
                  conversationId: conversationId) ??
              "UnImplemented Error";
      response = result;
      return response;
    } on PlatformException catch (e) {
      response = e.message.toString();
      return response;
    }
  }
}
