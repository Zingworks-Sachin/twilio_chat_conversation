import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_events.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_states.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/chats_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/models_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/widgets/bubble_widget.dart';
import 'package:twilio_chat_conversation_example/chat/common/widgets/chat_text_widget.dart';


class ChatDetailsScreen extends StatefulWidget {
  final String conversationName;
  final String conversationSid;
  final String? identity;
  const ChatDetailsScreen(
      {Key? key,
      required this.conversationName,
      required this.conversationSid,
      required this.identity})
      : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  ChatBloc? chatBloc;

  final msgController = TextEditingController();

  bool? isFromChatGpt = false;

  String typeMessages = "";

  List allMessageList = [];
  final ScrollController _controller = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc!
        .add(ReceiveMessageEvent(conversationName: widget.conversationSid));
    print("identity");
    print(widget.identity);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Conversation Details"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: BlocConsumer<ChatBloc, ChatStates>(
            builder: (BuildContext context, ChatStates state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: ListView.separated(
                    controller: _controller,
                    itemCount: allMessageList.length,
                    reverse: true,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final message = allMessageList[index];
                      // print(message['attributes']);
                      // print(message['author']);
                      var isMe = (message['author'] == widget.identity &&
                              message['attributes'] != "true")
                          ? true
                          : false;

                      return BubbleWidget(messageMap: message, isMe: isMe);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Padding(padding: EdgeInsets.only(bottom: 4)),
                  )),
                  ChatTextWidget(
                    hintText: "Type here..",
                    msgController: msgController,
                    haveValidation: true,
                    onSend: (typeMessage) {
                      print("typeMessage-" + typeMessage.toString());
                      List<String>? substrings = typeMessage.split(",");
                      if (substrings[0].contains("ChatGPT")) {
                        chatBloc!.add(SendMessageEvent(
                            enteredMessage: typeMessage,
                            conversationName: widget.conversationSid,
                            isFromChatGpt: false));
                        chatBloc!.add(SendMessageToChatGptEvent(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                            typeMessage: typeMessage));
                      } else {
                        chatBloc!.add(SendMessageEvent(
                            enteredMessage: typeMessage,
                            conversationName: widget.conversationSid,
                            isFromChatGpt: false));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }, listener: (BuildContext context, ChatStates state) {
          if (state is ReceiveMessageLoadedState) {
            allMessageList = state.messagesList;
            allMessageList
                .sort((a, b) => (b['dateCreated']).compareTo(a['dateCreated']));

            /// sort List<Map<String,dynamic>>
          }
          if (state is SendMessageToChatGptLoadingState) {
            // ProgressBar.show(context);
          }
          if (state is SendMessageLoadedState) {
            msgController.text = "";
            chatBloc!.add(
                ReceiveMessageEvent(conversationName: widget.conversationSid));
          }
          if (state is ReceiveMessageLoadedState) {
            // ProgressBar.dismiss(context);
          }
          if (state is SendMessageToChatGptLoadedState) {
            //ProgressBar.dismiss(context);
            //print("state.chatGptListList[0].msg");
            // print(state.chatGptListList[0].msg);
            chatBloc!.add(SendMessageEvent(
                enteredMessage: state.chatGptListList[0].msg,
                conversationName: widget.conversationSid,
                isFromChatGpt: true));
          }
        }));
  }
}
