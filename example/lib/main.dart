import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_events.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/chats_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/models_provider.dart';
import 'package:twilio_chat_conversation_example/chat/repository/chat_repository.dart';
import 'package:twilio_chat_conversation_example/chat/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( BlocProvider(
    create: (context) => ChatBloc(
      chatRepository: ChatRepositoryImpl(),
    ),
    child: const MyHomePage(title: 'Twilio Plugin',),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String platformVersion = 'Unknown';
  TwilioChatConversation twilioChatConversationPlugin = TwilioChatConversation();
  ChatBloc? chatBloc;

  @override
  void initState() {
    super.initState();
    listenToAccessTokenStatus();
  }
  listenToAccessTokenStatus(){
    chatBloc = BlocProvider.of<ChatBloc>(context);
    twilioChatConversationPlugin.onTokenStatusChange.listen((tokenData) {
      /// update token if your access token is about to expire
      if (tokenData["statusCode"] == 401){
        chatBloc?.add(UpdateTokenEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Running on: $platformVersion\n',
        home: BlocProvider(
          create: (context) => ChatBloc(
            chatRepository: ChatRepositoryImpl(),
          ),
          child: StreamBuilder<Map>(
              stream: TwilioChatConversation().onTokenStatusChange,
            builder: (context, snapshot) {
              return HomeScreen(platformVersion: platformVersion,);
            }
          ),
        ),
      ),
    );
  }
}