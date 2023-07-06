import Flutter
import UIKit
import Foundation

public class TwilioChatConversationPlugin: NSObject, FlutterPlugin {
    var conversationsHandler = ConversationsHandler()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "twilio_chat_conversation", binaryMessenger: registrar.messenger())
//      let channel = FlutterMethodChannel(name: "twilio_chat_conversation", binaryMessenger: registrar.messenger())

    let instance = TwilioChatConversationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
      let arguments = call.arguments as? [String:Any]
      print("call->\(String(describing: call.method))")
      print("arguments->\(String(describing: arguments))")
      
      
      switch call.method {
      case Methods.generateToken:
          TwilioApi.requestTwilioAccessToken(identity:arguments?["identity"] as! String) { [self] apiResult in
              switch apiResult {
              case .success(let accessToken):
                  self.conversationsHandler.loginWithAccessToken(accessToken) { loginResult in
                      guard let loginResultSuccessful: Bool = loginResult?.isSuccessful else {
                          return
                      }
                      if(loginResultSuccessful) {
                          result(Strings.authenticationSuccessful)
                      }else {
                          result(Strings.authenticationFailed)
                      }
                  }
              case .failure(let error):
                  print("Error requesting Twilio Access Token: \(error)")
                  result(Strings.authenticationFailed)
              }
          }
          break
          
      case Methods.createConversation:
          self.conversationsHandler.createConversation (uniqueConversationName: arguments?["conversationName"] as! String){ (success, conversation,status)  in
              if success, let conversation = conversation {
                  self.conversationsHandler.joinConversation(conversation) { tchConversationStatus in
                      
                  }
                  result(Strings.createConversationSuccess)
              }else {
                  if (status == "Conversation with provided unique name already exists") {
                      result(Strings.conversationExists)
                  } else {
                      result(Strings.createConversationFailure)
                  }
              }
          }
          break
          
      case Methods.getConversations:
          self.conversationsHandler.getConversations { conversationList in
              var listOfConversations: [[String: Any]] = []
              for conversation in conversationList {
                  var dictionary: [String: Any] = [:]
                  dictionary["conversationName"] = conversation.friendlyName
                  dictionary["sid"] = conversation.sid
                  dictionary["createdBy"] = conversation.createdBy
                  dictionary["dateCreated"] = conversation.dateCreated
                  dictionary["lastMessageDate"] = conversation.lastMessageDate?.description
                  dictionary["uniqueName"] = conversation.uniqueName
                  if (ConvertorUtility.isNilOrEmpty(dictionary["conversationName"]) == false && ConvertorUtility.isNilOrEmpty(dictionary["sid"]) == false){
                      listOfConversations.append(dictionary)
                  }
              }
              result(listOfConversations)
          }
          break
          
      case Methods.getParticipants:
          var listOfParticipants: [String] = []
          self.conversationsHandler.getParticipants(conversationId: arguments?["conversationId"] as! String) { participantsList in
              for user in participantsList{
                  if (!ConvertorUtility.isNilOrEmpty(user.identity)){
                      listOfParticipants.append(user.identity!)
                  }
              }
              result(listOfParticipants)
          }
          break
          
      case Methods.addParticipant:
          self.conversationsHandler.addParticipants(conversationId: arguments?["conversationId"] as! String, participantName: arguments?["participantName"] as! String) { status in
              if let addParticipantStatus = status {
                  if (addParticipantStatus.isSuccessful){
                      result(Strings.addParticipantSuccess)
                  }else {
                      result(addParticipantStatus.resultText)
                  }
              }
          }
          
      case Methods.joinConversation:
          self.conversationsHandler.getConversationFromId(conversationId: arguments?["conversationId"] as! String) { conversation in
              if let conversationFromId = conversation {
                  self.conversationsHandler.joinConversation(conversationFromId) { tchConversationStatus in
                      result(tchConversationStatus)
                  }
              }
          }
      case Methods.getMessages:
          self.conversationsHandler.getConversationFromId(conversationId: arguments?["conversationId"] as! String) { conversation in
              if let conversationFromId = conversation {
                  self.conversationsHandler.loadPreviousMessages(conversationFromId) { listOfMessagess in
                      result(listOfMessagess)
                  }
              }
          }
          break
          
      case Methods.sendMessage:
          self.conversationsHandler.sendMessage(conversationId: arguments?["conversationId"] as! String, messageText: arguments?["message"] as! String) { tchResult, tchMessages in
              if (tchResult.isSuccessful){
                  result("send")
              }else {
                  result(tchResult.resultText)
              }
          }
          break
          
      default:
          break
          
    }
  }
}

class EventManager {
    var eventHandler: (() -> Void)?
    
    func fireEvent() {
        // Trigger the event
        eventHandler?()
    }
}
