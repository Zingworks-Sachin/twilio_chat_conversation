import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:twilio_chat_conversation/twilio_chat_conversation.dart';
import 'package:twilio_chat_conversation_example/chat/bloc/chat_bloc.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/chats_provider.dart';
import 'package:twilio_chat_conversation_example/chat/common/providers/models_provider.dart';
import 'package:twilio_chat_conversation_example/chat/repository/chat_repository.dart';
import 'package:twilio_chat_conversation_example/chat/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final twilioChatConversationPlugin = TwilioChatConversation();
  runApp(StreamBuilder<Map>(
    stream: twilioChatConversationPlugin.onTokenStatusChange,
    builder: (context, snapshot) {
      return const MyHomePage(title: 'Twilio Plugin',);
    }
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

  @override
  void initState() {
    super.initState();
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
          child: HomeScreen(platformVersion: platformVersion,),
        ),
      ),
    );
  }
}