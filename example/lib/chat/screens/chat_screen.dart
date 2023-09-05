import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_events.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_states.dart';
import 'package:twilio_chat_conversation_example/chat/common/dialog_with_edittext.dart';
import 'package:twilio_chat_conversation_example/chat/common/toast_utility.dart';
import 'package:twilio_chat_conversation_example/chat/common/widgets/common_text_button_widget.dart';
import 'package:twilio_chat_conversation_example/chat/repository/chat_repository.dart';
import 'package:twilio_chat_conversation_example/chat/screens/chat_details_screen.dart';
import 'package:twilio_chat_conversation_example/chat/screens/conversation_list_screen.dart';

class ChatScreen extends StatefulWidget {
  final String? identity;
  const ChatScreen({Key? key, required this.identity}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatBloc? chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocConsumer<ChatBloc, ChatStates>(
          builder: (BuildContext context, ChatStates state) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: SvgPicture.asset(
                    "assets/images/twilio_logo_red.svg",
                    color: Colors.red,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              CommonTextButtonWidget(
                isIcon: false,
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.82,
                title: "Create Conversation",
                titleFontSize: 14.0,
                bgColor: Colors.blueGrey,
                borderColor: Colors.white,
                titleFontWeight: FontWeight.w600,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogWithEditText(
                        onPressed: (enteredText) {
                          chatBloc!.add(CreateConversationEvent(
                              conversationName: enteredText,
                              identity: widget.identity));
                          Navigator.of(context).pop();
                        },
                        dialogTitle: "Create Conversation",
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.030,
              ),
              CommonTextButtonWidget(
                isIcon: false,
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.82,
                bgColor: Colors.blueGrey,
                borderColor: Colors.white,
                title: "My Conversations",
                titleFontSize: 14.0,
                titleFontWeight: FontWeight.w600,
                onPressed: () {
                  chatBloc!.add(SeeMyConversationsEvent());
                },
              )

              // ElevatedButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return DialogWithEditText(
              //             onPressed: (enteredText) {
              //               chatBloc!.add(JoinConversionEvent(
              //                   conversationName: enteredText));
              //               Navigator.of(context).pop();
              //             },
              //           );
              //         },
              //       );
              //       //
              //     },
              //     child: const Text("Join Conversation")),
              // ElevatedButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return DialogWithEditText(
              //             onPressed: (enteredText) {
              //               chatBloc!.add(AddParticipantEvent(
              //                   participantName: enteredText,
              //                   conversationName: ""));
              //               Navigator.of(context).pop();
              //             },
              //           );
              //         },
              //       );
              //     },
              //     child: const Text("Add Participant")),
            ],
          ),
        );
      }, listener: (BuildContext context, ChatStates state) {
        if (state is CreateConversionLoadedState) {
          ToastUtility.showToastAtBottom(state.conversationAddedStatus);
        }
        if (state is JoinConversionLoadedState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) =>
                      ChatBloc(chatRepository: ChatRepositoryImpl()),
                  child: ChatDetailsScreen(
                      conversationName: '',
                      conversationSid: '',
                      identity: widget.identity)),
            ),
          );
        }
        if (state is SeeMyConversationsLoadedState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) =>
                      ChatBloc(chatRepository: ChatRepositoryImpl()),
                  child: ConversationListScreen(
                    conversationList: state.conversationList,
                    identity: widget.identity,
                  )),
            ),
          );
        }
      }),
    );
  }
}
