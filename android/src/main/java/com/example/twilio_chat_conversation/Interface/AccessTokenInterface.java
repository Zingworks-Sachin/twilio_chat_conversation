package com.example.twilio_chat_conversation.Interface;

import java.util.Map;

public interface AccessTokenInterface {
    default void onTokenStatusChange(Map status) {}
}
