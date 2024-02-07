protocol ConversationDelegate: AnyObject {
    func onMessageUpdate(message: [String:Any],  messageSubscriptionId : String)
//    func onTokenStatusChange(status: String)
}
