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

import java.util.ArrayList;
import java.util.HashMap;
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
  private ConversationsClient conversationClient;
  private Conversation conversation;
  private FlutterPluginBinding flutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation");
    channel.setMethodCallHandler(this);
    this.flutterPluginBinding = flutterPluginBinding;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method) {
      case Methods.generateToken:
        String accessToken = generateAccessToken(call.argument("accountSid"),call.argument("apiKey"),call.argument("apiSecret"),call.argument("identity"));
        System.out.println("accessToken generated->"+accessToken);
        init(accessToken,result);
        break;

      case Methods.createConversation:
        String createConversationResult = createConversation(call.argument("conversationName"),call.argument("identity"),result);
        System.out.println("createConversationResult->"+createConversationResult);
        result.success("Success");
        break;

      case Methods.getConversations:
        List<Map<String, Object>> conversationList = getConversationsList();
        System.out.println("conversationList->"+conversationList.toString());
        result.success(conversationList);
        break;

      case Methods.getMessagesFromConversation:
        System.out.println("conversationId->"+call.argument("conversationId").toString());
        getAllMessages(call.argument("conversationId"),result);
        break;

      case Methods.joinConversation:
        String joinStatus =  joinConversation(call.argument("conversationId"));
        System.out.println("joinStatus->"+joinStatus.toString());
        result.success(joinStatus);
        break;

      case Methods.sendMessage:
        sendMessages(call.argument("message"),call.argument("conversationId"), Boolean.TRUE.equals(call.argument("isFromChatGpt")),result);
        break;

      case Methods.addParticipant:
        String addedStatus =  addParticipant(call.argument("participantName"),call.argument("conversationId"),result);
        break;

      case Methods.receiveMessages:
        receiveMessages(call.argument("conversationId"));
        break;

      case Methods.getParticipants:
        getParticipants(call.argument("conversationId"),result);
        break;

      default:
        break;
    }
  }

  private void getParticipants(String conversationId, Result result) {
    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation conversation) {
        List<Participant> participantList = conversation.getParticipantsList();
        List<String> participants = new ArrayList<>();;

        for (int i=0;i<participantList.size();i++){
          System.out.println(participantList.get(i).getIdentity()+"--"+participantList.get(i).getSid());
          participants.add(participantList.get(i).getIdentity());
          System.out.println("getParticipants->" + participants.toString());
        }
//        System.out.println("getParticipants->" + participantList.toString());
        result.success(participants);
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
        List<Participant> participantList = new ArrayList<>();;
        result.success(participantList);
      }
    });
  }

  public String createConversation(String conversationName, String identity, Result result) {
    final String[] conversationId = {""};
    conversationClient.createConversation(conversationName, new CallbackListener<Conversation>() {

      @Override
      public void onSuccess(Conversation conversations) {
        System.out.println("conversation-" + conversationName);
        conversation = conversations;
        conversationId[0] = conversations.getSid();
        String added = addParticipant(identity, conversationName, result);
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        System.out.println("onError->" + errorInfo.getMessage());
        result.success("Error While Creating Conversation");
        CallbackListener.super.onError(errorInfo);
      }
    });
    return conversationId[0];
  }
  public String addParticipant(String participantName, String conversationId, Result result){

    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation conversation) {
        // Retrieve the conversation object using the conversation SID
        conversation.addParticipantByIdentity(participantName,null,new StatusListener() {
          @Override
          public void onSuccess() {
            System.out.println("added successfully->"+conversationId);
            List<Participant> participantList = conversation.getParticipantsList();
            System.out.println("participantList->"+participantList.toString());
            result.success("added successfully");
          }

          @Override
          public void onError(ErrorInfo errorInfo) {
            result.success("Error While Adding");
            StatusListener.super.onError(errorInfo);
          }
        });
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
      }
    });


    return "added";

  }
  public String joinConversation(String conversationId){
    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation result) {
        // Retrieve the conversation object using the conversation SID
        result.join(new StatusListener() {

          @Override
          public void onSuccess() {
            System.out.println("joined->");
            receiveMessages(conversationId);
            // sendMessages();
          }
          @Override
          public void onError(ErrorInfo errorInfo) {
            System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

            StatusListener.super.onError(errorInfo);
          }
        });

      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
      }
    });
    return conversationId;
  }
  public String sendMessages(String enteredMessage, String conversationId, boolean isFromChatGpt, Result result){

    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation conversation) {
        // Join the conversation with the given participant identity
        System.out.println("enteredMessage-" + conversation.getUniqueName());
        Attributes attributes = new Attributes(isFromChatGpt);
        conversation.prepareMessage()
                .setAttributes(attributes)
                .setBody(enteredMessage)
                .buildAndSend(new CallbackListener() {


                  @Override
                  public void onSuccess(Object data) {
                    System.out.println("senddd");
                    receiveMessages(conversationId);
                    result.success("send");
                  }

                  @Override
                  public void onError(ErrorInfo errorInfo) {
                    System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

                  }
                });
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
      }
    });
    return "send";
  }
  void receiveMessages(String conversationId){
    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation result) {
        // Retrieve the conversation object using the conversation SID

        // Join the conversation with the given participant identity
        result.addListener(new ConversationListener() {
          @Override
          public void onMessageAdded(Message message) {
            System.out.println("message"+message.getBody());

            System.out.println("message"+message.getParticipant().getSid());
          }

          @Override
          public void onMessageUpdated(Message message, Message.UpdateReason reason) {

          }

          @Override
          public void onMessageDeleted(Message message) {

          }

          @Override
          public void onParticipantAdded(Participant participant) {

          }

          @Override
          public void onParticipantUpdated(Participant participant, Participant.UpdateReason reason) {

          }


          @Override
          public void onParticipantDeleted(Participant participant) {

          }

          @Override
          public void onTypingStarted(Conversation conversation, Participant participant) {

          }

          @Override
          public void onTypingEnded(Conversation conversation, Participant participant) {

          }

          @Override
          public void onSynchronizationChanged(Conversation conversation) {

          }
        });
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

        CallbackListener.super.onError(errorInfo);
      }
    });
  }

  void getParticipantList(){
    conversationClient.getConversation("CH122e85471f6a44ac8ebbec124cce5f0b",new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation result) {
        // Retrieve the conversation object using the conversation SID

        // Join the conversation with the given participant identity
        List<Participant> participantList = result.getParticipantsList();
        for (int i=0;i<participantList.size();i++){
          System.out.println(participantList.get(i).getIdentity());
        }
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
      }
    });

  }

  public List<Map<String, Object>> getConversationsList(){
    List<Conversation> conversationList = conversationClient.getMyConversations();
    System.out.println(conversationList.size()+"");
    List<Map<String, Object>> list = new ArrayList<>();
    for (int i=0;i<conversationList.size();i++){
      // Map conversationMap = new HashMap<>();
      Map<String, Object> conversationMap = new HashMap<>();
      conversationMap.put("sid",conversationList.get(i).getSid());
      conversationMap.put("conversationName",conversationList.get(i).getFriendlyName());
      list.add(conversationMap);
    }
    return  list;
  }


  public List<Map<String, Object>> getAllMessages(String conversationId, Result result){
    List<Map<String, Object>> list = new ArrayList<>();
    conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){

      @Override
      public void onSuccess(Conversation conversation) {
        conversation.getLastMessages(100, new CallbackListener<List<Message>>() {

          @Override
          public void onSuccess(List<Message> messagesList) {
            for (int i=0;i<messagesList.size();i++){
              // Map conversationMap = new HashMap<>();
              Map<String, Object> messagesMap = new HashMap<>();
              messagesMap.put("sid",messagesList.get(i).getSid());
              messagesMap.put("author",messagesList.get(i).getAuthor());
              messagesMap.put("body",messagesList.get(i).getBody());
              messagesMap.put("attributes",messagesList.get(i).getAttributes().toString());
              messagesMap.put("dateCreated",messagesList.get(i).getDateCreated());
              System.out.println("messagesMap-"+messagesList.get(i).getDateCreated());

              list.add(messagesMap);

            }
            System.out.println("list->"+list);
            result.success(list);
          }

          @Override
          public void onError(ErrorInfo errorInfo) {
            // Error occurred while retrieving the messages
            System.out.println("Error retrieving messages: " + errorInfo.getMessage());
          }
        });
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        CallbackListener.super.onError(errorInfo);
      }
    });
    return list;
  }
  public static String generateAccessToken(String accountSid, String apiKey, String apiSecret, String identity) {
    // Create an AccessToken builder
    AccessToken.Builder builder = new AccessToken.Builder(accountSid, apiKey, apiSecret);
    // Set the identity of the token
    builder.identity(identity);
    // Create a Chat grant and add it to the token
    ChatGrant chatGrant = new ChatGrant();
    chatGrant.setServiceSid("IS1b4142e65b0f482fb795e2c48d028f45");
    builder.grant(chatGrant);

    // Build the token
    AccessToken token = builder.build();
//    generateAccessToken = token.toJwt();
    return token.toJwt();
  }

  void init(String accessToken, Result result){
    String sdkVersionName = getSdkVersion();
    System.out.println("sdkVersionName->"+sdkVersionName);
//    String accessToken = generateAccessToken;

    ConversationsClient.Properties props = ConversationsClient.Properties.newBuilder().createProperties();
    ConversationsClient.create(flutterPluginBinding.getApplicationContext(), accessToken, props, new CallbackListener<ConversationsClient>() {
      @Override
      public void onSuccess(ConversationsClient client) {
        System.out.println("client11-" + client.getMyIdentity().toString());
        conversationClient = client;
        result.success("Authentication Successfull");
      }

      @Override
      public void onError(ErrorInfo errorInfo) {
        System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
        result.success("Authentication Failed");
      }
    });
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
