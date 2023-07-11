protocol MessageDelegate: AnyObject {
    func onMessageUpdate( message: [String:Any],  messageSubscriptionId : String)
}
