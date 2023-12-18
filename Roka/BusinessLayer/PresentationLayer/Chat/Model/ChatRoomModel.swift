//
//  SpaceListResponseModel.swift
//  Organisaur
//
//  Created by dev on 11/05/22.
//

import Foundation

struct ChatRoomModel: Codable {
    var chat_dialog_id: String?
    var name: String?
    var pic: String?
    var dialog_type: Int?
    var dialog_status: [String: Int]?
    var dialog_admin: String?

    var last_message_id, last_message_sender_name, last_message_sender_id: String?
    var last_message: [String: String]?

    var last_message_type: Int?
    var last_message_time: Int64?
        
    var user_id, user_name, user_pic: [String: String]?
    var clear_chat_time: [String: Int64]?
    
    var dialog_create_time: Int64?
    var unread_count, block_status, premium_status: [String: Int]?
    
    var dialog_conversation: Int?
    
    var is_connection, message_count, message_length, message_sent: [String: Int]?
    var gift_date, message_date, creation_date: [String: Int64]?
    
    var user_number: [String: String]?
}
