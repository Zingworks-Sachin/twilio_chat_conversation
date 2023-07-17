import 'package:equatable/equatable.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/chats_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/models_provider.dart';

abstract class ChatEvents extends Equatable {}

class GenerateTokenEvent extends ChatEvents {
  final Map credentials;
  GenerateTokenEvent({required this.credentials});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateTokenEvent extends ChatEvents {
  UpdateTokenEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitializeConversationClientEvent extends ChatEvents {
  final String accessToken;
  InitializeConversationClientEvent({required this.accessToken});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversion
class CreateConversationEvent extends ChatEvents {
  final String conversationName;
  final String? identity;
  CreateConversationEvent(
      {required this.conversationName, required this.identity});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversion
class JoinConversionEvent extends ChatEvents {
  final String conversationId;
  final String conversationName;
  JoinConversionEvent({required this.conversationId,required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class SendMessageEvent extends ChatEvents {
  final String? enteredMessage;
  final String? conversationName;
  final bool? isFromChatGpt;
  SendMessageEvent(
      {required this.enteredMessage,
      required this.conversationName,
      required this.isFromChatGpt});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class ReceiveMessageEvent extends ChatEvents {
  final String? conversationId;
  final int? messageCount;
  ReceiveMessageEvent({required this.conversationId,this.messageCount});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//AddParticipant
class AddParticipantEvent extends ChatEvents {
  final String participantName;
  final String conversationName;
  AddParticipantEvent(
      {required this.participantName, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//AddParticipant
class SeeMyConversationsEvent extends ChatEvents {
  SeeMyConversationsEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}
class GetParticipantsEvent extends ChatEvents {
  final String conversationId;
  GetParticipantsEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class SendMessageToChatGptEvent extends ChatEvents {
  final ModelsProvider modelsProvider;
  final ChatProvider chatProvider;
  final String typeMessage;
  SendMessageToChatGptEvent(
      {required this.modelsProvider,
      required this.chatProvider,
      required this.typeMessage});

  @override
  List<Object?> get props => throw UnimplementedError();
}
