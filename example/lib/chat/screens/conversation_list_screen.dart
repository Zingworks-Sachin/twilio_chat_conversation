import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_events.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_states.dart';
import 'package:twilio_chat_conversation_example/chat/common/dialog_with_edittext.dart';
import 'package:twilio_chat_conversation_example/chat/common/progress_bar.dart';
import 'package:twilio_chat_conversation_example/chat/common/shared_preference.dart';
import 'package:twilio_chat_conversation_example/chat/common/toast_utility.dart';
import 'package:twilio_chat_conversation_example/chat/repository/chat_repository.dart';
import 'package:twilio_chat_conversation_example/chat/screens/chat_details_screen.dart';

class ConversationListScreen extends StatefulWidget {
  final List conversationList;
  final String? identity;
  const ConversationListScreen(
      {Key? key, required this.conversationList, required this.identity})
      : super(key: key);

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  ChatBloc? chatBloc;

  String? identity;

  var conversationName = "";
  var conversationSid = "";
  String loggedInUserIdentity = "";

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    getLoggedInUser();
  }

  void getLoggedInUser() async {
    loggedInUserIdentity = await SharedPreference.getIdentity();
    print("loggedInUserIdentity->$loggedInUserIdentity");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversations'),
          backgroundColor: Colors.black12,
        ),
        backgroundColor: Colors.black12,
        body: BlocConsumer<ChatBloc, ChatStates>(
            builder: (BuildContext context, ChatStates state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ListView.builder(
                itemCount: widget.conversationList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.blueGrey,
                        elevation: 10,
                        child: ListTile(
                          title: Text(
                            widget.conversationList[index]["conversationName"],
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            widget.conversationList[index]["sid"],
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogWithEditText(
                                          onPressed: (enteredText) {
                                            conversationName =
                                                widget.conversationList[index]
                                                    ["conversationName"];
                                            conversationSid = widget
                                                .conversationList[index]["sid"];
                                            chatBloc!.add(AddParticipantEvent(
                                                participantName: enteredText,
                                                conversationName: widget
                                                        .conversationList[index]
                                                    ["sid"]));
                                            Navigator.of(context).pop();
                                          },
                                          dialogTitle: "Add Participant",
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.person_add_alt_1_sharp,
                                    color: Colors.cyanAccent,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    chatBloc!.add(JoinConversionEvent(
                                        conversationId: widget
                                            .conversationList[index]["sid"],
                                        conversationName:
                                            widget.conversationList[index]
                                                ["conversationName"]));
                                  },
                                  icon: const Icon(
                                    Icons.chat,
                                    color: Colors.greenAccent,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    chatBloc!.add(GetParticipantsEvent(
                                        conversationId: widget
                                            .conversationList[index]["sid"]));
                                  },
                                  icon: const Icon(
                                    Icons.people_alt_rounded,
                                    color: Colors.limeAccent,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }, listener: (BuildContext context, ChatStates state) {
          if (state is AddParticipantLoadedState) {
            ToastUtility.showToastAtBottom(state.addedStatus);
          }
          if (state is RemoveParticipantLoadedState) {
            ToastUtility.showToastAtBottom(state.result);
          }
          if (state is JoinConversionLoadedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) =>
                        ChatBloc(chatRepository: ChatRepositoryImpl()),
                    child: ChatDetailsScreen(
                      conversationName: state.conversationName,
                      conversationSid: state.result,
                      identity: widget.identity,
                    )),
              ),
            );
          }

          if (state is GetParticipantsLoadingState) {
            ProgressBar.show(context);
          }
          if (state is GetParticipantsLoadedState) {
            ProgressBar.dismiss(context);
            showBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (c) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                spreadRadius: 5)
                          ]),
                      // height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.people_outline_outlined,
                                  size: 30,
                                  color: Colors.limeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Participants",
                                    style: TextStyle(
                                        color: Colors.limeAccent,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.all(10.0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (c, i) {
                              return const Divider(
                                height: 2.0,
                              );
                            },
                            itemBuilder: (context, participantIndex) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 20,
                                            color: Colors.brown,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${state.participantsList[participantIndex]["identity"]} ${(state.participantsList[participantIndex]["isAdmin"]) ? "(Admin)" : ""}",
                                              style: const TextStyle(
                                                  color: Colors.brown,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (state.participantsList[
                                                      participantIndex]
                                                  ["conversationCreatedBy"] ==
                                              loggedInUserIdentity &&
                                          (state.participantsList[
                                                      participantIndex]
                                                  ["identity"] !=
                                              loggedInUserIdentity))
                                        IconButton(
                                          onPressed: () async {
                                            // print(
                                            //     "participantsList sid->${state.participantsList[participantIndex]["sid"]}");
                                            // print(
                                            //     "conversationList sid->${state.participantsList[participantIndex]["conversationSid"]}");
                                            chatBloc!.add(RemoveParticipantEvent(
                                                participantName:
                                                    state.participantsList[
                                                            participantIndex]
                                                        ["identity"],
                                                conversationName:
                                                    state.participantsList[
                                                            participantIndex]
                                                        ["conversationSid"]));
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: state.participantsList.length,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          if (state is GetParticipantsErrorState) {
            ProgressBar.dismiss(context);
            ToastUtility.showToastAtCenter(
                "Something went wrong. Please try again later.");
          }
        }));
  }
}
