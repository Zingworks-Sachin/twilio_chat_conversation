package com.example.twilio_chat_conversation;

import com.example.twilio_chat_conversation.Interface.MessageInterface;
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
import io.flutter.plugin.common.MethodChannel;

class ConversationHandler {
    /// Entry point for the Conversations SDK.
    protected static  ConversationsClient conversationClient;
    protected static FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private static MessageInterface listener;

    /// Generate token and authenticate user #
    protected static String generateAccessToken(String accountSid, String apiKey, String apiSecret, String identity, String serviceSid) {
        // Create an AccessToken builder
        AccessToken.Builder builder = new AccessToken.Builder(accountSid, apiKey, apiSecret);
        // Set the identity of the token
        builder.identity(identity);
        // Create a Chat grant and add it to the token
        ChatGrant chatGrant = new ChatGrant();
        chatGrant.setServiceSid(serviceSid);
        builder.grant(chatGrant);
        // Build the token
        AccessToken token = builder.build();
        return token.toJwt();
    }
    /// Create new conversation #
    protected static void createConversation(String conversationName, String identity, MethodChannel.Result result) {
        conversationClient.createConversation(conversationName, new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversations) {
                addParticipant(identity, conversationName, result);
                result.success(Strings.createConversationSuccess);
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                if (errorInfo.getMessage().equals("Conversation with provided unique name already exists")){
                    result.success(Strings.conversationExists);
                }else {
                    result.success(Strings.createConversationFailure);
                }
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Add participant in a conversation #
    protected static void addParticipant(String participantName, String conversationId, MethodChannel.Result result){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation conversation) {
                // Retrieve the conversation object using the conversation SID
                conversation.addParticipantByIdentity(participantName,null,new StatusListener() {
                    @Override
                    public void onSuccess() {
                        result.success(Strings.addParticipantSuccess);
                    }

                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        StatusListener.super.onError(errorInfo);
                        result.success(errorInfo.getMessage());
                    }
                });
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    ///Join the existing conversation #
    protected static String joinConversation(String conversationId){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation result) {
                // Retrieve the conversation object using the conversation SID
                result.join(new StatusListener() {
                    @Override
                    public void onSuccess() {
                    }
                    @Override
                    public void onError(ErrorInfo errorInfo) {
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
    /// Send message #
    protected static void sendMessages(String enteredMessage, String conversationId, boolean isFromChatGpt, MethodChannel.Result result){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation conversation) {
                // Join the conversation with the given participant identity
                Attributes attributes = new Attributes(isFromChatGpt);
                conversation.prepareMessage()
                        .setAttributes(attributes)
                        .setBody(enteredMessage)
                        .buildAndSend(new CallbackListener() {
                            @Override
                            public void onSuccess(Object data) {
                                result.success("send");
                            }
                            @Override
                            public void onError(ErrorInfo errorInfo) {
                            }
                        });
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Subscribe To Message Update #
    protected static void subscribeToMessageUpdate(String conversationId){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation result) {
                // Join the conversation with the given participant identity
                result.addListener(new ConversationListener() {
                    @Override
                    public void onMessageAdded(Message message) {
                        try {
                            Map<String, Object> messageMap = new HashMap<>();
                            messageMap.put("sid",message.getSid());
                            messageMap.put("author",message.getAuthor());
                            messageMap.put("body",message.getBody());
                            messageMap.put("attributes",message.getAttributes().toString());
                            messageMap.put("dateCreated",message.getDateCreated());
                            System.out.println("messageMap-"+message.getDateCreated());
                            triggerEvent(messageMap);
                        }catch (Exception e){
                            System.out.println("Exception-"+e.getMessage());
                        }
                    }

                    @Override
                    public void onMessageUpdated(Message message, Message.UpdateReason reason) {
                        System.out.println("onMessageUpdated->"+message.toString());
                        System.out.println("reason->"+reason.toString());
                    }

                    @Override
                    public void onMessageDeleted(Message message) {
                        System.out.println("onMessageDeleted->"+message.toString());
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
                        System.out.println("onSynchronizationChanged");

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
    /// Unsubscribe To Message Update #
    protected static void unSubscribeToMessageUpdate(String conversationId){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation result) {
                /// Retrieve the conversation object using the conversation SID
                result.removeAllListeners();
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Get list of conversations for logged in user #
    protected static List<Map<String, Object>> getConversationsList() {
        List<Conversation> conversationList = conversationClient.getMyConversations();
        System.out.println(conversationList.size()+"");
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i=0;i<conversationList.size();i++){
            // Map conversationMap = new HashMap<>();
            Map<String, Object> conversationMap = new HashMap<>();
            conversationMap.put("sid",conversationList.get(i).getSid());
            conversationMap.put("conversationName",conversationList.get(i).getFriendlyName());
            conversationMap.put("createdBy",conversationList.get(i).getCreatedBy());
            conversationMap.put("dateCreated",conversationList.get(i).getDateCreated());
//            conversationMap.put("lastMessageDate",conversationList.get(i).getLastMessageDate().toString());
            conversationMap.put("uniqueName",conversationList.get(i).getUniqueName());

            if (conversationList.get(i).getFriendlyName() != null && !conversationList.get(i).getFriendlyName().trim().isEmpty()) {
                list.add(conversationMap);
            }
        }
        System.out.println("list"+list);
        return  list;
    }
    /// Get messages from the specific conversation #
    protected static void getAllMessages(String conversationId, MethodChannel.Result result) {
        List<Map<String, Object>> list = new ArrayList<>();
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversation) {
                conversation.getLastMessages(1000, new CallbackListener<List<Message>>() {
                    @Override
                    public void onSuccess(List<Message> messagesList) {
                        for (int i=0; i<messagesList.size(); i++) {
                            Map<String, Object> messagesMap = new HashMap<>();
                            messagesMap.put("sid",messagesList.get(i).getSid());
                            messagesMap.put("author",messagesList.get(i).getAuthor());
                            messagesMap.put("body",messagesList.get(i).getBody());
                            messagesMap.put("attributes",messagesList.get(i).getAttributes().toString());
                            messagesMap.put("dateCreated",messagesList.get(i).getDateCreated());
                            list.add(messagesMap);
                        }
                        result.success(list);
                    }
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        /// Error occurred while retrieving the messages
                        System.out.println("Error retrieving messages: " + errorInfo.getMessage());
                    }
                });
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    protected static void init(String accessToken, MethodChannel.Result result) {
        ConversationsClient.Properties props = ConversationsClient.Properties.newBuilder().createProperties();
        ConversationsClient.create(flutterPluginBinding.getApplicationContext(), accessToken, props, new CallbackListener<ConversationsClient>() {
            @Override
            public void onSuccess(ConversationsClient client) {
                ConversationHandler.conversationClient = client;
                result.success(Strings.authenticationSuccessful);
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                result.success("Authentication Failed");
            }
        });
    }
    /// Get participants from the specific conversation #
    protected static void getParticipants(String conversationId, MethodChannel.Result result) {
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversation) {
                List<Participant> participantList = conversation.getParticipantsList();
                List<String> participants = new ArrayList<>();
                for (int i=0;i<participantList.size();i++){
                    participants.add(participantList.get(i).getIdentity());
                    System.out.println("getParticipants->" + participants);
                }
                result.success(participants);
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
                List<Participant> participantList = new ArrayList<>();
                result.success(participantList);
            }
        });
    }
    public void setListener(MessageInterface listener) {
        ConversationHandler.listener = listener;
    }
    public static void triggerEvent(Map message) {
        // Pass the result through the listener
        if (listener != null) {
            listener.onMessageUpdate(message);
        }
    }
}