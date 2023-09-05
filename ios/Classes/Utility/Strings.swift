import Foundation

class Strings {
    
    /// Used when conversation is created successfully
    static let createConversationSuccess: String = "Conversation created successfully."

    /// Used when there is an error while creating a conversation
    static let createConversationFailure: String = "Error while creating conversation."
    
    /// Used when conversation with provided name already exists
    static let conversationExists: String = "Conversation with provided unique name already exists"
    
    /// Used when participant is added to a conversation successfully
    static let addParticipantSuccess: String = "Participant added successfully."
    
    /// Used when participant is added to a conversation successfully
    static let removedParticipantSuccess: String = "Participant removed successfully."
    
    /// Used when authentication is successful
    static let authenticationSuccessful: String = "Authentication Successful"
    
    /// Used when authentication is unsuccessful
    static let authenticationFailed: String = "Authentication Failed"
    
    /// Used when twilio access token is about to expire
    static let accessTokenWillExpire: String = "Access token will expire"
    
    /// Used when twilio access token is expired
    static let accessTokenExpired: String = "Access token expired"
    
    /// Used when twilio access token is refreshed
    static let accessTokenRefreshed: String = "Access token refreshed"
}
