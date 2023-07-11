package com.example.twilio_chat_conversation;
import java.util.Map;
import io.flutter.plugin.common.EventChannel;

public interface MessageDelegate {
    void setEventSink(EventChannel.EventSink eventSink);
    void onMessageUpdate(Map event);
}