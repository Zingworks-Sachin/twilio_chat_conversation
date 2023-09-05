import 'package:equatable/equatable.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/chat_model.dart';

abstract class ChatStates extends Equatable {}

class ChatInitialState extends ChatStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// GenerateTokenLoadingState
class GenerateTokenLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// GenerateTokenLoadedState
class GenerateTokenLoadedState extends ChatStates {
  final String token;
  GenerateTokenLoadedState({required this.token});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionErrorState
class GenerateTokenErrorState extends ChatStates {
  final String message;
  GenerateTokenErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateTokenLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// UpdateTokenLoadedState
class UpdateTokenLoadedState extends ChatStates {
  final Map tokenStatus;
  UpdateTokenLoadedState({required this.tokenStatus});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// UpdateTokenErrorState
class UpdateTokenErrorState extends ChatStates {
  final String message;
  UpdateTokenErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitializeConversationClientLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

class InitializeConversationClientLoadedState extends ChatStates {
  final String result;
  InitializeConversationClientLoadedState({required this.result});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitializeConversationClientErrorState extends ChatStates {
  final String message;
  InitializeConversationClientErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionLoadingState
class CreateConversionLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// CreateConversionLoadedState
class CreateConversionLoadedState extends ChatStates {
  final String conversationAddedStatus;
  CreateConversionLoadedState({required this.conversationAddedStatus});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversionErrorState
class CreateConversionErrorState extends ChatStates {
  final String message;
  CreateConversionErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversionLoadingState
class JoinConversionLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// JoinConversionLoadedState
class JoinConversionLoadedState extends ChatStates {
  final String result;
  final String conversationName;
  JoinConversionLoadedState(
      {required this.result, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversionErrorState
class JoinConversionErrorState extends ChatStates {
  final String message;
  JoinConversionErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SendMessageLoadingState
class SendMessageLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// SendMessageLoadedState
class SendMessageLoadedState extends ChatStates {
  final String status;
  SendMessageLoadedState({required this.status});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SendMessageErrorState
class SendMessageErrorState extends ChatStates {
  final String message;
  SendMessageErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// ReceiveMessageLoadingState
class ReceiveMessageLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// ReceiveMessageLoadedState
class ReceiveMessageLoadedState extends ChatStates {
  final List messagesList;
  ReceiveMessageLoadedState({required this.messagesList});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// ReceiveMessageErrorState
class ReceiveMessageErrorState extends ChatStates {
  final String message;
  ReceiveMessageErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// AddParticipantLoadingState
class AddParticipantLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class AddParticipantLoadedState extends ChatStates {
  final String addedStatus;
  AddParticipantLoadedState({required this.addedStatus});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// AddParticipantErrorState
class AddParticipantErrorState extends ChatStates {
  final String message;
  AddParticipantErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class RemoveParticipantLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class RemoveParticipantLoadedState extends ChatStates {
  final String result;
  RemoveParticipantLoadedState({required this.result});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// AddParticipantErrorState
class RemoveParticipantErrorState extends ChatStates {
  final String message;
  RemoveParticipantErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SeeMyConversationsLoadingState
class SeeMyConversationsLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class SeeMyConversationsLoadedState extends ChatStates {
  final List conversationList;
  SeeMyConversationsLoadedState({required this.conversationList});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SeeMyConversationsErrorState
class SeeMyConversationsErrorState extends ChatStates {
  final String message;
  SeeMyConversationsErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SeeMyConversationsLoadingState
class SendMessageToChatGptLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class SendMessageToChatGptLoadedState extends ChatStates {
  final List<ChatModel> chatGptListList;
  SendMessageToChatGptLoadedState({required this.chatGptListList});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SeeMyConversationsErrorState
class SendMessageToChatGptErrorState extends ChatStates {
  final String message;
  SendMessageToChatGptErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetParticipantsLoadingState extends ChatStates {
  @override
  List<Object?> get props => [];
}

// AddParticipantLoadedState
class GetParticipantsLoadedState extends ChatStates {
  final List participantsList;
  GetParticipantsLoadedState({required this.participantsList});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// SeeMyConversationsErrorState
class GetParticipantsErrorState extends ChatStates {
  final String message;
  GetParticipantsErrorState({required this.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}
