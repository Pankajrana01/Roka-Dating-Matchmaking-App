//
//  UserFirebaseModel.swift
//  Roka
//
//  Created by Applify  on 12/01/23.
//

import Foundation

struct UserDataModel {
    var user_id: String?
    var chat_dialog_ids: [String: String]?
    
    var message_date: Int64?
    var message_dialog: [String: String]?
    var dialog_count: Int?
}

extension UserDataModel {
    init(dict: [String: AnyObject]) throws {
        self.init(
            user_id: dict["user_id"] as? String ?? "",
            chat_dialog_ids: dict["chat_dialog_ids"] as? [String: String] ?? [:],

            message_date: dict["message_date"] as? Int64 ?? 0,
            message_dialog: dict["message_dialog"] as? [String: String] ?? [:],
            dialog_count: dict["dialog_count"] as? Int ?? 0
        )
    }
}
