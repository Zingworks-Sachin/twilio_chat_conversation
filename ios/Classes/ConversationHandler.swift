import UIKit
import TwilioConversationsClient

class ConversationsHandler: NSObject, TwilioConversationsClientDelegate {

    // MARK: Conversations variables
    private var client: TwilioConversationsClient?
    weak var messageDelegate: MessageDelegate?
    public var messageSubscriptionId: String = ""

//    func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
//        guard status == .completed else {
//            return
//        }
//
//        checkConversationCreation { (_, conversation) in
//           if let conversation = conversation {
//               self.joinConversation(conversation)
//           } else {
//               self.createConversation(uniqueConversationName:conversation?.uniqueName ?? self.uniqueConversationName) { (success, conversation) in
//                   if success, let conversation = conversation {
//                       self.joinConversation(conversation)
//                   }
//               }
//           }
//        }
//    }


    // Called whenever a conversation we've joined receives a new message
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation,
                    messageAdded message: TCHMessage) {
                self.getMessageInDictionary(message) { messageDictionary in
            if let messageDict = messageDictionary {
                var updatedMessage: [String: Any] = [:]
                updatedMessage["conversationId"] = conversation.sid ?? ""
                updatedMessage["message"] = messageDict
                self.messageDelegate?.onMessageUpdate(message: updatedMessage, messageSubscriptionId: self.messageSubscriptionId)
            }
        }
    }
    
    func conversationsClientTokenWillExpire(_ client: TwilioConversationsClient) {
        print("Access token will expire.")
        refreshAccessToken()
    }
    
    func conversationsClientTokenExpired(_ client: TwilioConversationsClient) {
        print("Access token expired.")
        refreshAccessToken()
    }
    
    private func refreshAccessToken() {
//        guard let identity = identity else {
//            return
//        }
//        let urlString = "\(TOKEN_URL)?identity=\(identity)"
//
//        TokenUtils.retrieveToken(url: urlString) { (token, _, error) in
//            guard let token = token else {
//               print("Error retrieving token: \(error.debugDescription)")
//               return
//           }
//            self.client?.updateToken(token, completion: { (result) in
//                if (result.isSuccessful) {
//                    print("Access token refreshed")
//                } else {
//                    print("Unable to refresh access token")
//                }
//            })
//        }
    }

    func sendMessage(conversationId:String, messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
            self.getConversationFromId(conversationId: conversationId) { conversation in
            conversation?.prepareMessage().setBody(messageText).buildAndSend(completion: { tchResult, tchMessages in
                completion(tchResult,tchMessages)
            })
        }
    }
    
    func loginWithAccessToken(_ token: String, completion: @escaping (TCHResult?) -> Void) {
        // Set up Twilio Conversations client
        TwilioConversationsClient.conversationsClient(withToken: token,
         properties: nil,
         delegate: self) { (result, client) in
           self.client = client
            completion(result)
        }
    }

    func shutdown() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }

    func createConversation(uniqueConversationName:String,_ completion: @escaping (Bool, TCHConversation?,String) -> Void) {
        guard let client = client else {
            return
        }
        // Create the conversation if it hasn't been created yet
        let options: [String: Any] = [
            TCHConversationOptionUniqueName: uniqueConversationName,
            TCHConversationOptionFriendlyName: uniqueConversationName,
            ]
        client.createConversation(options: options) { (result, conversation) in
            if result.isSuccessful {
                completion(result.isSuccessful, conversation,result.resultText ?? "Conversation created.")
            } else {
                completion(false, conversation,result.error?.localizedDescription ?? "Conversation NOT created.")
            }
        }
    }

    func getConversations(_ completion: @escaping([TCHConversation]) -> Void) {
        guard let client = client else {
            return
        }
        completion(client.myConversations() ?? [])
    }
    
    func getParticipants(conversationId:String,_ completion: @escaping([TCHParticipant]) -> Void) {
        self.getConversationFromId(conversationId: conversationId) { conversation in
            completion(conversation?.participants() ?? [])
        }
    }
    
    func addParticipants(conversationId:String,participantName:String,_ completion: @escaping(TCHResult?) -> Void) {
        self.getConversationFromId(conversationId: conversationId) { conversation in
            conversation?.addParticipant(byIdentity: participantName, attributes: nil,completion: { status in
                completion(status)
            })
        }
    }

    func joinConversation(_ conversation: TCHConversation,_ completion: @escaping(String?) -> Void) {
        if conversation.status == .joined {
            self.loadPreviousMessages(conversation) { listOfMessages in
                
            }
        } else {
            conversation.join(completion: { result in
                if result.isSuccessful {
                    self.loadPreviousMessages(conversation) { listOfMessages in
                        
                    }
                }
            })
        }
        completion(conversation.sid)
    }
    
    func getConversationFromId(conversationId:String,_ completion: @escaping(TCHConversation?) -> Void){
        guard let client = client else {
            return
        }
        client.conversation(withSidOrUniqueName: conversationId) { (result, conversation) in
            if let conversationFromSid = conversation {
                completion(conversationFromSid)
            }
        }
    }
    
    func loadPreviousMessages(_ conversation: TCHConversation,_ completion: @escaping([[String: Any]]?) -> Void) {
        var listOfMessagess: [[String: Any]] = []
        conversation.getLastMessages(withCount: 1000) { (result, messages) in
            if let messagesList = messages {
                messagesList.forEach { message in
                    self.getMessageInDictionary(message) { messageDictionary in
                        if let messageDict = messageDictionary {
                            listOfMessagess.append(messageDict)
                        }
                    }
                }
                completion(listOfMessagess)
            }
        }
    }
    
    func getMessageInDictionary(_ message:TCHMessage,_ completion: @escaping([String: Any]?) -> Void) {
        var dictionary: [String: Any] = [:]
        var attachedMedia: [[String: Any]] = []
        
        message.attachedMedia.forEach { media in
            var mediaDictionary: [String: Any] = [:]
            mediaDictionary["filename"] = media.filename ?? ""
            mediaDictionary["contentType"] = media.contentType
            mediaDictionary["sid"] = media.sid
            mediaDictionary["description"] = media.description
            mediaDictionary["size"] = media.size
            attachedMedia.append(mediaDictionary)
        }

        dictionary["sid"] = message.participantSid
        dictionary["author"] = message.author
        dictionary["body"] = message.body
        dictionary["attributes"] = message.attributes()?.string
        dictionary["dateCreated"] = message.dateCreated
        dictionary["participant"] = message.participant?.identity
        dictionary["participantSid"] = message.participantSid
        dictionary["description"] = message.description
        dictionary["index"] = message.index
        dictionary["attachedMedia"] = attachedMedia
        completion(dictionary)
    }
}
