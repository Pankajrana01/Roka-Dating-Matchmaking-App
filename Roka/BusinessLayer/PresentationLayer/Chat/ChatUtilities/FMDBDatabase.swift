//
//  DBHelper.swift
//  Roka
//
//  Created by Applify  on 13/09/22.
//

import UIKit
import FMDB

class FMDBDatabase {
    
    public typealias Completion = ((Bool, Error?)-> Void)
    
    public typealias ResultCompletion = ((Bool, FMResultSet?, Error?)-> Void)
    
    /*
     * @description singleton to access the database
     */
    static let sharedDatabase:FMDatabase = {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("roka.sqlite")
        let database = FMDatabase(url: fileURL)
        return database
    }()
    
    /*
     * @description singleton to access a serial queue for updating the database
     */
    static let sharedQueue: FMDatabaseQueue = {
        let documents = try! FileManager.default
            .url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documents.appendingPathComponent("roka.sqlite")
        return FMDatabaseQueue(path: fileURL.path)!
    }()
    
    static func insert(values:[Any]) {
        /* we need to specify NULL when using VALUES for any autoincremented keys */
        do {
            if !sharedDatabase.isOpen {
                sharedDatabase.open()
            }
            
            let sqlStatement = "CREATE TABLE IF NOT EXISTS Messages (ID Integer Primary key AutoIncrement, message_id Text, message Text, message_type Integer, message_time BigInt, firebase_message_time BigInt, chat_dialog_id Text, sender_id Text, attachment_url Text, receiver_id Text, reply_msg Text, reply_id Text, reply_type Integer, reply_msg_id Text)"
            sharedDatabase.executeStatements(sqlStatement)
            
            for item in values {
                if let dict = item as? [String: Any] {
                    let sqlStatement = "INSERT OR REPLACE INTO Messages VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                    try sharedDatabase.executeUpdate(sqlStatement, values: [dict["messageId"] as? String ?? "", dict["message"] as? String ?? "", dict["messageType"] as? Int ?? 1, dict["messageTime"] ?? 0, dict["firebaseMessageTime"] ?? 0, dict["chatDialogId"] as? String ?? "", dict["senderId"] as? String ?? "", dict["attachmentUrl"] as? String ?? "", dict["receiverId"] as? String ?? "", dict["reply_msg"] as? String ?? "", dict["reply_id"] as? String ?? "", dict["reply_type"] as? Int ?? 0, dict["reply_msg_id"] as? String ?? ""])
                }
            }
            sharedDatabase.close()
        } catch {
            print("failed: \(error.localizedDescription)")
            sharedDatabase.close()
        }
    }
    
    static func insertMessage(message: MessageModel) {
        /* we need to specify NULL when using VALUES for any autoincremented keys */
        var receiverStr: String?

        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(message.receiver_id) {
            receiverStr = String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        do {
            if !sharedDatabase.isOpen {
                sharedDatabase.open()
            }
            
            let sqlCreateStatement = "CREATE TABLE IF NOT EXISTS Messages (ID Integer Primary key AutoIncrement, message_id Text, message Text, message_type Integer, message_time BigInt, firebase_message_time BigInt, chat_dialog_id Text, sender_id Text, attachment_url Text, receiver_id Text, reply_msg Text, reply_id Text, reply_type Integer, reply_msg_id Text)"
            sharedDatabase.executeStatements(sqlCreateStatement)
            
            let sqlStatement = "INSERT OR REPLACE INTO Messages VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            try sharedDatabase.executeUpdate(sqlStatement, values: [message.message_id!,  message.message!, message.message_type!, message.message_time!, message.firebase_message_time!, message.chat_dialog_id!, message.sender_id!, message.attachment_url!, receiverStr ?? "", message.reply_msg!, message.reply_id!, message.reply_type!, message.reply_msg_id!])
            
            sharedDatabase.close()
        } catch {
            print("failed: \(error.localizedDescription)")
            sharedDatabase.close()
        }
    }
        
    static func query(where conditions:[WhereCondition]? = nil, completion:ResultCompletion){
        var sqlStatement = "SELECT * FROM Messages"
        
        var values = [Any]()
        if let conditions = conditions {
            sqlStatement += " WHERE"
            for (index, condition) in conditions.enumerated() {
                values.append(condition.value)
                sqlStatement += " \(condition.column) = ?"
                sqlStatement += (index == conditions.count - 1) ? "" :","
            }
            sqlStatement += " ORDER BY message_time ASC"
        }
        
        do {
            if !sharedDatabase.isOpen {
                sharedDatabase.open()
            }
            let fmresult = try sharedDatabase.executeQuery(sqlStatement, values: values)
            completion(true, fmresult, nil)
            sharedDatabase.close()
        } catch {
            completion(false, nil, error)
            sharedDatabase.close()
        }
    }
    
    static func deleteAllMessagesOfGroup(chat_dialog_id: String) {
        do {
            if !sharedDatabase.isOpen {
                sharedDatabase.open()
            }

            try sharedDatabase.executeUpdate("DELETE FROM Messages WHERE chat_dialog_id = ?", values: [chat_dialog_id ])
            sharedDatabase.close()
        } catch {
            print("failed: \(error.localizedDescription)")
            sharedDatabase.close()
        }
    }
}

struct WhereCondition {
    var column = ""
    var value = ""
}
