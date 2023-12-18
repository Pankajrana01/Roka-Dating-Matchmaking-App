//
//  MessageModel.swift
//  Organisaur
//
//  Created by Applify  on 28/08/22.
//

import Foundation

struct MessageModel {
    var message_id: String?
    var message: String?

    var message_type: Int?
    var message_time: Int64?
    var firebase_message_time: Int64?

    var chat_dialog_id: String?
    var sender_id: String?
    var attachment_url: String?

    var receiver_id: [String: String]?

    var reply_msg: String?
    var reply_id: String?
    var reply_type: Int?
    var reply_msg_id: String?
   // var user_name : String?
}

extension MessageModel {    
    init(fromDB: [AnyHashable : Any]) throws {
        self.init(
            message_id: fromDB["message_id"] as? String ?? "",
            message: fromDB["message"] as? String ?? "",

            message_type: fromDB["message_type"] as? Int ?? 1,
            message_time: fromDB["message_time"] as? Int64 ?? 0,
            firebase_message_time: fromDB["firebase_message_time"] as? Int64 ?? 0,

            chat_dialog_id: fromDB["chat_dialog_id"] as? String ?? "",
            sender_id: fromDB["sender_id"] as? String ?? "",
            attachment_url: fromDB["attachment_url"] as? String == "" ? "" : (fromDB["attachment_url"] as? String ?? ""),
            
            receiver_id: MessageModel.convertStringToDictionary(text: fromDB["receiver_id"] as? String ?? "") as? [String: String] ?? [:],

            reply_msg: fromDB["reply_msg"] as? String ?? "",
            reply_id: fromDB["reply_id"] as? String ?? "",
            reply_type: fromDB["reply_type"] as? Int ?? 0,
            reply_msg_id: fromDB["reply_msg_id"] as? String ?? ""
          //  user_name: fromDB["user_name"] as? String? ?? ""
        )
    }
    
    init(dict: [String: AnyObject]) throws {
        self.init(
            message_id: dict["message_id"] as? String ?? "",
            message: dict["message"] as? String ?? "",

            message_type: dict["message_type"] as? Int ?? 1,
            message_time: dict["message_time"] as? Int64 ?? 0,
            firebase_message_time: dict["firebase_message_time"] as? Int64 ?? 0,

            chat_dialog_id: dict["chat_dialog_id"] as? String ?? "",
            sender_id: dict["sender_id"] as? String ?? "",
            attachment_url: dict["attachment_url"] as? String == "" ? "" : (dict["attachment_url"] as? String ?? ""),

            receiver_id: dict["receiver_id"] as? [String: String] ?? [:],

            reply_msg: dict["reply_msg"] as? String ?? "",
            reply_id: dict["reply_id"] as? String ?? "",
            reply_type: dict["reply_type"] as? Int ?? 0,
            reply_msg_id: dict["reply_msg_id"] as? String ?? ""
          //  user_name: dict["user_name"] as? String? ?? ""
        )
    }
    
    static func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
}
