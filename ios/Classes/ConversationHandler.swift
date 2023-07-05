import UIKit
import TwilioConversationsClient

class ConversationsHandler: NSObject, TwilioConversationsClientDelegate {

    // the unique name of the conversation you create
    private let uniqueConversationName = "general"

    // MARK: Conversations variables
    private var client: TwilioConversationsClient?
    private var conversation: TCHConversation?
    private(set) var messages: [TCHMessage] = []
    private var identity: String?
    
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
        messages.append(message)

        // Changes to the delegate should occur on the UI thread
//        DispatchQueue.main.async {
//            if let delegate = self.delegate {
//                delegate.reloadMessages()
//                delegate.receivedNewMessage()
//            }
//        }
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

    func sendMessage(_ messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        
//        let messageOptions = TCHMessageOptions().withBody(messageText)
//        conversation?.sendMessage(with: messageOptions, completion: { (result, message) in
//            completion(result, message)
//        })
    
    }

    func loginFromServer(_ identity: String, completion: @escaping (Bool) -> Void) {
        // Fetch Access Token from the server and initialize the Conversations Client
//        let urlString = "\(TOKEN_URL)?identity=\(identity)"
//        self.identity = identity
//
//        TokenUtils.retrieveToken(url: urlString) { (token, _, error) in
//            guard let token = token else {
//                print("Error retrieving token: \(error.debugDescription)")
//                completion(false)
//                return
//            }
//            // Set up Twilio Conversations client
//            TwilioConversationsClient.conversationsClient(withToken: token,
//                                                          properties: nil,
//                                                          delegate: self) { (result, client) in
//                                                            self.client = client
//                                                            completion(result.isSuccessful)
//            }
//        }
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
            print("else called")
            return
        }
        completion(client.myConversations() ?? [])
    }
    
//    func checkConversationCreation(uniqueConversationName:String,_ completion: @escaping(TCHResult?, TCHConversation?) -> Void) {
//
//        guard let client = client else {
//            print("else called")
//            return
//        }
//
//        client.conversation(withSidOrUniqueName: uniqueConversationName) { (result, conversation) in
//            completion(result, conversation)
//        }
//        let myConversations = client.myConversations()
//        completion(TCHResult(), client.myConversations()?.first)
//    }
    
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
        self.conversation = conversation
        if conversation.status == .joined {
            print("Current user already exists in conversation")
            self.loadPreviousMessages(conversation) { listOfMessages in
                
            }
        } else {
            conversation.join(completion: { result in
                print("Result of conversation join: \(result.resultText ?? "No Result")")
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
        conversation.getLastMessages(withCount: 100) { (result, messages) in
            if let messagesList = messages {
                messagesList.forEach { message in
                    
                    var dictionary: [String: Any] = [:]
                    
                    print("type->\(type(of: messages))---author->\(String(describing: message.author))---messages->\(String(describing: message.body))" )
                    

                    dictionary["sid"] = message.participantSid
                    dictionary["author"] = message.author
                    dictionary["body"] = message.body
//                    dictionary["attributes"] = message.attributes()
                    dictionary["dateCreated"] = message.dateCreated
                    listOfMessagess.append(dictionary)
                }
                completion(listOfMessagess)
            }
        }
    }
}
