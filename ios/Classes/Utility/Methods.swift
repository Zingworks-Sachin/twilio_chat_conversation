import Foundation

class Methods {
    
    /// The method channel name used to interact with the native platform.
    static let generateToken: String = "generateToken"
    static let createConversation: String = "createConversation"
    static let getConversations: String = "getConversations"
    static let getMessages: String = "getMessages"
    static let joinConversation: String = "joinConversation"
    static let sendMessage: String = "sendMessage"
    static let addParticipant: String = "addParticipant"
    static let removeParticipant: String = "removeParticipant"
    static let receiveMessages: String = "receiveMessages"
    static let getParticipants: String = "getParticipants"
    static let unSubscribeToMessageUpdate: String = "unSubscribeToMessageUpdate"
    static let subscribeToMessageUpdate: String = "subscribeToMessageUpdate"
    static let initializeConversationClient: String = "initializeConversationClient"
    static let updateAccessToken: String = "updateAccessToken"
}
