//
//  ConvertorUtility.swift
//  twilio_chat_conversation
//
//  Created by Zingworks-MBP-1 on 05/07/23.
//

import Foundation

class ConvertorUtility {
    
    static func isNilOrEmpty(_ value: Any?) -> Bool {
        if let str = value as? String {
            return str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        if let collection = value as? (any Collection) {
            return collection.isEmpty
        }
        
        return value == nil
    }
}
