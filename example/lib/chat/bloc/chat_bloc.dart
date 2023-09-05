import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_events.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_states.dart';
import 'package:twilio_chat_conversation_example/chat/common/models/chat_model.dart';
import 'package:twilio_chat_conversation_example/chat/common/shared_preference.dart';
import 'package:twilio_chat_conversation_example/chat/common/value_string.dart';
import 'package:twilio_chat_conversation_example/chat/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  ChatRepository chatRepository;
  ChatStates get initialState => ChatInitialState();

  ChatBloc({required this.chatRepository}) : super(ChatInitialState()) {
    on<GenerateTokenEvent>((event, emit) async {
      emit(GenerateTokenLoadingState());
      try {
        String result = "";

        /// For android you can either use generateToken of the plugin or get token from server
        if (Platform.isAndroid) {
          result = await chatRepository.generateToken(event.credentials);
        } else {
          result =
              await chatRepository.getAccessTokenFromServer(event.credentials);
        }
        if (result != "") {
          emit(GenerateTokenLoadedState(token: result));
        } else {
          emit(GenerateTokenErrorState(
              message: ValueString.errorGettingAccessToken));
        }
      } catch (e) {
        emit(GenerateTokenErrorState(message: e.toString()));
      }
    });
    on<UpdateTokenEvent>((event, emit) async {
      emit(UpdateTokenLoadingState());
      try {
        String identity = await SharedPreference.getIdentity();
        String accessToken = await chatRepository
            .getAccessTokenFromServer({"identity": identity});
        Map tokenStatus = await chatRepository.updateAccessToken(accessToken);
        emit(UpdateTokenLoadedState(tokenStatus: tokenStatus));
      } catch (e) {
        emit(GenerateTokenErrorState(message: e.toString()));
      }
    });
    on<InitializeConversationClientEvent>((event, emit) async {
      emit(InitializeConversationClientLoadingState());
      try {
        String result = await chatRepository
            .initializeConversationClient(event.accessToken);
        if (result == ValueString.authenticationSuccessful) {
          emit(InitializeConversationClientLoadedState(result: result));
        } else {
          emit(GenerateTokenErrorState(
              message: ValueString.errorGettingAccessToken));
        }
      } catch (e) {
        emit(GenerateTokenErrorState(message: e.toString()));
      }
    });
    on<CreateConversationEvent>((event, emit) async {
      emit(CreateConversionLoadingState());
      try {
        String result = await chatRepository.createConversation(
            event.conversationName, event.identity);
        emit(CreateConversionLoadedState(conversationAddedStatus: result));
      } catch (e) {
        emit(CreateConversionErrorState(message: e.toString()));
      }
    });
    on<SeeMyConversationsEvent>((event, emit) async {
      emit(SeeMyConversationsLoadingState());
      try {
        List result = await chatRepository.seeMyConversations();
        emit(SeeMyConversationsLoadedState(conversationList: result));
      } catch (e) {
        emit(CreateConversionErrorState(message: e.toString()));
      }
    });
    on<JoinConversionEvent>((event, emit) async {
      emit(JoinConversionLoadingState());
      try {
        String result =
            await chatRepository.joinConversation(event.conversationId);
        emit(JoinConversionLoadedState(
            result: result, conversationName: event.conversationName));
      } catch (e) {
        emit(JoinConversionErrorState(message: e.toString()));
      }
    });
    on<SendMessageEvent>((event, emit) async {
      emit(SendMessageLoadingState());
      try {
        String result = await chatRepository.sendMessage(
            event.enteredMessage, event.conversationName, event.isFromChatGpt);
        emit(SendMessageLoadedState(status: result));
      } catch (e) {
        emit(SendMessageErrorState(message: e.toString()));
      }
    });
    on<AddParticipantEvent>((event, emit) async {
      emit(AddParticipantLoadingState());
      try {
        String result = await chatRepository.addParticipant(
            event.participantName, event.conversationName);
        emit(AddParticipantLoadedState(addedStatus: result));
      } catch (e) {
        emit(AddParticipantErrorState(message: e.toString()));
      }
    });

    on<RemoveParticipantEvent>((event, emit) async {
      emit(RemoveParticipantLoadingState());
      try {
        String result = await chatRepository.removeParticipant(
            event.participantName, event.conversationName);
        emit(RemoveParticipantLoadedState(result: result));
      } catch (e) {
        emit(RemoveParticipantErrorState(message: e.toString()));
      }
    });

    on<ReceiveMessageEvent>((event, emit) async {
      emit(ReceiveMessageLoadingState());
      try {
        List result = await chatRepository.getMessages(
            event.conversationId, event.messageCount);

        emit(ReceiveMessageLoadedState(messagesList: result));
      } catch (e) {
        emit(ReceiveMessageErrorState(message: e.toString()));
      }
    });
    on<SendMessageToChatGptEvent>((event, emit) async {
      emit(SendMessageToChatGptLoadingState());
      try {
        List<ChatModel> result = await chatRepository.sendMessageToChatGpt(
            event.modelsProvider, event.chatProvider, event.typeMessage);

        emit(SendMessageToChatGptLoadedState(chatGptListList: result));
      } catch (e) {
        emit(SendMessageToChatGptErrorState(message: e.toString()));
      }
    });
    on<GetParticipantsEvent>((event, emit) async {
      emit(GetParticipantsLoadingState());
      try {
        List result =
            await chatRepository.getParticipants(event.conversationId);
        emit(GetParticipantsLoadedState(participantsList: result));
      } catch (e) {
        emit(GetParticipantsErrorState(message: e.toString()));
      }
    });
  }
}
