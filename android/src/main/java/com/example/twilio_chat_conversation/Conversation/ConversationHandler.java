package com.example.twilio_chat_conversation.Conversation;

import com.example.twilio_chat_conversation.Interface.AccessTokenInterface;
import com.example.twilio_chat_conversation.Interface.MessageInterface;
import com.example.twilio_chat_conversation.Utility.Strings;
import com.twilio.conversations.Attributes;
import com.twilio.conversations.CallbackListener;
import com.twilio.conversations.Conversation;
import com.twilio.conversations.ConversationListener;
import com.twilio.conversations.ConversationsClient;
import com.twilio.conversations.ConversationsClientListener;
import com.twilio.conversations.Message;
import com.twilio.conversations.Participant;
import com.twilio.conversations.StatusListener;
import com.twilio.conversations.User;
import com.twilio.jwt.accesstoken.AccessToken;
import com.twilio.jwt.accesstoken.ChatGrant;
import com.twilio.util.ErrorInfo;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class ConversationHandler {
    /// Entry point for the Conversations SDK.
    public static  ConversationsClient conversationClient;
    public static FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private static MessageInterface messageInterface;
    private static AccessTokenInterface accessTokenInterface;

    /// Generate token and authenticate user #
    public static String generateAccessToken(String accountSid, String apiKey, String apiSecret, String identity, String serviceSid) {
        // Create an AccessToken builder
        AccessToken.Builder builder = new AccessToken.Builder(accountSid, apiKey, apiSecret);
        // Set the identity of the token
        builder.identity(identity);
//        builder.ttl(0);
        builder.ttl(3600);
        // Create a Chat grant and add it to the token
        ChatGrant chatGrant = new ChatGrant();
        chatGrant.setServiceSid(serviceSid);
        builder.grant(chatGrant);
        // Build the token
        AccessToken token = builder.build();
        return token.toJwt();
    }
    /// Create new conversation #
    public static void createConversation(String conversationName, String identity, MethodChannel.Result result) {
        conversationClient.createConversation(conversationName, new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversations) {
                addParticipant(identity, conversationName, result);
                result.success(Strings.createConversationSuccess);
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                if (errorInfo.getMessage().equals(Strings.conversationExists)){
                    result.success(Strings.conversationExists);
                }else {
                    result.success(Strings.createConversationFailure);
                }
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Add participant in a conversation #
    public static void addParticipant(String participantName, String conversationId, MethodChannel.Result result){
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
    /// Remove participant in a conversation #
    public static void removeParticipant(String participantName, String conversationId, MethodChannel.Result result){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation conversation) {
                // Retrieve the conversation object using the conversation SID
                System.out.println("admin-"+conversation.getCreatedBy()+"---"+conversationClient.getMyIdentity());

//                if (conversationClient.getMyIdentity().equals(conversation.getCreatedBy())){
                    conversation.removeParticipantByIdentity(participantName,new StatusListener() {
                        @Override
                        public void onSuccess() {
                            result.success(Strings.removedParticipantSuccess);
                        }

                        @Override
                        public void onError(ErrorInfo errorInfo) {
                            StatusListener.super.onError(errorInfo);
                            result.success(errorInfo.getMessage());
                        }
                    });
//                }
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    ///Join the existing conversation #
    public static String joinConversation(String conversationId){
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
    public static void sendMessages(String enteredMessage, String conversationId, boolean isFromChatGpt, MethodChannel.Result result){
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
    public static void subscribeToMessageUpdate(String conversationId){
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
                            //System.out.println("messageMap-"+message.getDateCreated());
                            triggerEvent(messageMap);
                        }catch (Exception e){
                            //System.out.println("Exception-"+e.getMessage());
                        }
                    }

                    @Override
                    public void onMessageUpdated(Message message, Message.UpdateReason reason) {
                        //System.out.println("onMessageUpdated->"+message.toString());
                        //System.out.println("reason->"+reason.toString());
                    }

                    @Override
                    public void onMessageDeleted(Message message) {
                        //System.out.println("onMessageDeleted->"+message.toString());
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
                        System.out.println("conversation onSynchronizationChanged->"+conversation.getSynchronizationStatus().toString());
                    }
                });
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                //System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Unsubscribe To Message Update #
    public static void unSubscribeToMessageUpdate(String conversationId){
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>(){
            @Override
            public void onSuccess(Conversation result) {
                /// Retrieve the conversation object using the conversation SID
                result.removeAllListeners();
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                //System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    /// Get list of conversations for logged in user #
    public static List<Map<String, Object>> getConversationsList() {
        List<Conversation> conversationList = conversationClient.getMyConversations();
        //System.out.println(conversationList.size()+"");
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i=0;i<conversationList.size();i++){
            // Map conversationMap = new HashMap<>();
            Map<String, Object> conversationMap = new HashMap<>();
            conversationMap.put("sid",conversationList.get(i).getSid());
            conversationMap.put("conversationName",conversationList.get(i).getFriendlyName());
            conversationMap.put("createdBy",conversationList.get(i).getCreatedBy());
            conversationMap.put("dateCreated",conversationList.get(i).getDateCreated());
            conversationMap.put("uniqueName",conversationList.get(i).getUniqueName());

            if (conversationList.get(i).getFriendlyName() != null && !conversationList.get(i).getFriendlyName().trim().isEmpty()) {
                list.add(conversationMap);
            }
        }
        //System.out.println("list"+list);
        return  list;
    }
    /// Get messages from the specific conversation #
    public static void getAllMessages(String conversationId, Integer messageCount, MethodChannel.Result result) {
        List<Map<String, Object>> list = new ArrayList<>();
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversation) {
                conversation.getLastMessages((messageCount != null) ? messageCount :1000, new CallbackListener<List<Message>>() {
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
                        //System.out.println("Error retrieving messages: " + errorInfo.getMessage());
                    }
                });
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
    }
    public static void initializeConversationClient(String accessToken, MethodChannel.Result result) {
        ConversationsClient.Properties props = ConversationsClient.Properties.newBuilder().createProperties();
        ConversationsClient.create(flutterPluginBinding.getApplicationContext(), accessToken, props, new CallbackListener<ConversationsClient>() {
            @Override
            public void onSuccess(ConversationsClient client) {
                conversationClient = client;
                conversationClient.addListener(new ConversationsClientListener() {

                    @Override
                    public void onConversationAdded(Conversation conversation) {
                        //System.out.println("onConversationAdded");
                    }

                    @Override
                    public void onConversationUpdated(Conversation conversation, Conversation.UpdateReason reason) {

                    }

                    @Override
                    public void onConversationDeleted(Conversation conversation) {

                    }

                    @Override
                    public void onConversationSynchronizationChange(Conversation conversation) {

                    }

                    @Override
                    public void onError(ErrorInfo errorInfo) {

                    }

                    @Override
                    public void onUserUpdated(User user, User.UpdateReason reason) {

                    }

                    @Override
                    public void onUserSubscribed(User user) {

                    }

                    @Override
                    public void onUserUnsubscribed(User user) {

                    }

                    @Override
                    public void onClientSynchronization(ConversationsClient.SynchronizationStatus synchronizationStatus) {
                        System.out.print("onClientSynchronization synchronizationStatus->"+synchronizationStatus.getValue());
                        if (synchronizationStatus == ConversationsClient.SynchronizationStatus.COMPLETED) {
                            System.out.print("Client Synchronized");
                        }
                    }

                    @Override
                    public void onNewMessageNotification(String conversationSid, String messageSid, long messageIndex) {

                    }

                    @Override
                    public void onAddedToConversationNotification(String conversationSid) {

                    }

                    @Override
                    public void onRemovedFromConversationNotification(String conversationSid) {

                    }

                    @Override
                    public void onNotificationSubscribed() {

                    }

                    @Override
                    public void onNotificationFailed(ErrorInfo errorInfo) {

                    }

                    @Override
                    public void onConnectionStateChange(ConversationsClient.ConnectionState state) {

                    }

                    @Override
                    public void onTokenExpired() {
                        System.out.println("onTokenExpired");
                        Map<String, Object> tokenStatusMap = new HashMap<>();
                        tokenStatusMap.put("statusCode",401);
                        tokenStatusMap.put("message",Strings.accessTokenExpired);
                        onTokenStatusChange(tokenStatusMap);
                    }

                    @Override
                    public void onTokenAboutToExpire() {
                        //System.out.println("onTokenAboutToExpire");
                        Map<String, Object> tokenStatusMap = new HashMap<>();
                        tokenStatusMap.put("statusCode",200);
                        tokenStatusMap.put("message",Strings.accessTokenWillExpire);
                        onTokenStatusChange(tokenStatusMap);
                    }
                });
                result.success(Strings.authenticationSuccessful);
            }
            @Override
            public void onError(ErrorInfo errorInfo) {
                result.success(Strings.authenticationFailed);
            }
        });
    }
    /// Get participants from the specific conversation #
    public static void getParticipants(String conversationId, MethodChannel.Result result) {
        conversationClient.getConversation(conversationId,new CallbackListener<Conversation>() {
            @Override
            public void onSuccess(Conversation conversation) {
                List<Participant> participantList = conversation.getParticipantsList();
                List<Map<String, Object>> participants = new ArrayList<>();
                for (int i=0;i<participantList.size();i++) {
                    Map<String, Object> participantMap = new HashMap<>();
                    participantMap.put("identity",participantList.get(i).getIdentity());
                    participantMap.put("sid",participantList.get(i).getSid());
                    participantMap.put("conversationSid",participantList.get(i).getConversation().getSid());
                    participantMap.put("conversationCreatedBy",participantList.get(i).getConversation().getCreatedBy());
                    participantMap.put("dateCreated",participantList.get(i).getConversation().getDateCreated());
                    participantMap.put("isAdmin", Objects.equals(participantList.get(i).getConversation().getCreatedBy(), participantList.get(i).getIdentity()));
                    participants.add(participantMap);
                    System.out.println("participantMap->" + participantMap);
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

    public static void updateAccessToken(String accessToken, MethodChannel.Result result) {
        Map<String, Object> tokenStatus = new HashMap<>();
        conversationClient.updateToken(accessToken ,new StatusListener() {
            @Override
            public void onSuccess() {
                System.out.println("Refreshed access token.");
                tokenStatus.put("statusCode",200);
                tokenStatus.put("message",Strings.accessTokenRefreshed);
                result.success(tokenStatus);
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                StatusListener.super.onError(errorInfo);
                tokenStatus.put("statusCode",500);
                tokenStatus.put("message",errorInfo.getMessage());
                result.success(tokenStatus);
            }
        });
    }

    public void setListener(MessageInterface listener) {
        ConversationHandler.messageInterface = listener;
    }
    public void setTokenListener(AccessTokenInterface listener) {
        ConversationHandler.accessTokenInterface = listener;
    }
    public static void triggerEvent(Map message) {
        // Pass the result through the messageInterface
        if (messageInterface != null) {
            messageInterface.onMessageUpdate(message);
        }
    }
    public static void onTokenStatusChange(Map status) {
        // Pass the result through the messageInterface
        //System.out.println("accessTokenInterface->" + accessTokenInterface.toString());
        if (accessTokenInterface != null) {
            accessTokenInterface.onTokenStatusChange(status);
        }
    }
}