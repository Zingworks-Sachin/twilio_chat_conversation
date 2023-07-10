protocol MessageDelegate: AnyObject {
    func messageUpdated( message: [String:Any],  messageSubscriptionId : String)
}
