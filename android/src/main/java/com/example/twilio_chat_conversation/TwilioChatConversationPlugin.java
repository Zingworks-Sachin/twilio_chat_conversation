package com.example.twilio_chat_conversation;

import static com.twilio.conversations.ConversationsClient.getSdkVersion;

import androidx.annotation.NonNull;

import com.twilio.conversations.Attributes;
import com.twilio.conversations.CallbackListener;
import com.twilio.conversations.Conversation;
import com.twilio.conversations.ConversationListener;
import com.twilio.conversations.ConversationsClient;
import com.twilio.conversations.Message;
import com.twilio.conversations.Participant;
import com.twilio.conversations.StatusListener;
import com.twilio.jwt.accesstoken.AccessToken;
import com.twilio.jwt.accesstoken.ChatGrant;
import com.twilio.util.ErrorInfo;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** TwilioChatConversationPlugin */
public class TwilioChatConversationPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation");
    channel.setMethodCallHandler(this);
    ConversationHandler.flutterPluginBinding = flutterPluginBinding;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method) {
      // Generate token and authenticate user #
      case Methods.generateToken: //Generate token and authenticate user
        String accessToken = ConversationHandler.generateAccessToken(call.argument("accountSid"),call.argument("apiKey"),call.argument("apiSecret"),call.argument("identity"),call.argument("serviceSid"));
        System.out.println("accessToken generated->"+accessToken);
        ConversationHandler.init(accessToken,result);
        break;

      // Create new conversation #
      case Methods.createConversation:
        ConversationHandler.createConversation(call.argument("conversationName"),call.argument("identity"),result);
        break;

      // Get list of conversations for logged in user #
      case Methods.getConversations:
        List<Map<String, Object>> conversationList = ConversationHandler.getConversationsList();
        result.success(conversationList);
        break;

      // Get messages from the specific conversation #
      case Methods.getMessages:
        ConversationHandler.getAllMessages(call.argument("conversationId"),result);
        break;

      //Join the existing conversation #
      case Methods.joinConversation:
        String joinStatus =  ConversationHandler.joinConversation(call.argument("conversationId"));
        result.success(joinStatus);
        break;

      // Send message #
      case Methods.sendMessage:
        ConversationHandler.sendMessages(call.argument("message"),call.argument("conversationId"), Boolean.TRUE.equals(call.argument("isFromChatGpt")),result);
        break;

      // Add participant in a conversation #
      case Methods.addParticipant:
        ConversationHandler.addParticipant(call.argument("participantName"),call.argument("conversationId"),result);
        break;

      // Get messages from the specific conversation #
      case Methods.receiveMessages:
        ConversationHandler.receiveMessages(call.argument("conversationId"));
        break;

      // Get participants from the specific conversation #
      case Methods.getParticipants:
        ConversationHandler.getParticipants(call.argument("conversationId"),result);
        break;

      default:
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
