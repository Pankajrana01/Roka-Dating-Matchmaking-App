//
//  FirestoreManager.swift
//  Roka
//
//  Created by Applify  on 22/08/22.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

class FirestoreManager {
    static let lastMessageRegex = "123@App@Default@Message@321"

    static func signInOnFirebase() {
        let email = "rokadatingapp@gmail.com"
        let password = "RokaDating@123"
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if let err = error as NSError?, let code = AuthErrorCode.Code(rawValue: err.code) {
                switch code {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    break
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    break
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    break
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    break
                default:
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            } else {
                print("User signs in successfully")
            }
        }
    }
    
    // MARK: - Create Chatroom
    static func justCheckIfChatRoomExist(chatDialogId: String, completionHandler: @escaping ((Bool, ChatRoomModel?) -> Void)) {        
        let chatDB = Database.database().reference().child("Chats/\(chatDialogId)")
        chatDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                //Already Exist
                if let snapDict = snapshot.value as? [String:AnyObject] {
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                        completionHandler(true, model)
                        
                    } catch _ {
                        completionHandler(false, nil)
                    }
                } else {
                    completionHandler(false, nil)
                }
                
            } else {
                //New Chatroom
                completionHandler(false, nil)
            }
        })
    }
    
    static func checkForChatRoom(sendDataModel: FirebaseSendDataModel, completionHandler: @escaping ((Bool, ChatRoomModel?) -> Void)) {
        let userIdsArray = [UserModel.shared.user.id, sendDataModel.id ?? ""].sorted{ $0 < $1 }
        let chatDialogId = userIdsArray.joined(separator: ",")
        
        let chatDB = Database.database().reference().child("Chats/\(chatDialogId)")
        chatDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                //Already Exist
                if let snapDict = snapshot.value as? [String:AnyObject] {
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                        completionHandler(true, model)
                        
                    } catch _ {
                        completionHandler(false, nil)
                    }
                } else {
                    completionHandler(false, nil)
                }
                
            } else {
                //New Chatroom
                let model = FirestoreManager.createOneToOneChatRoom(sendDataModel: sendDataModel)
                completionHandler(true, model)
            }
        })
    }
    
    static func createOneToOneChatRoom(sendDataModel: FirebaseSendDataModel) -> ChatRoomModel {
        let ref = Database.database().reference()
        let user = UserModel.shared.user
        let otherUserId = sendDataModel.id ?? ""
        let chatDialogId = ([user.id, otherUserId].sorted{ $0 < $1 }).joined(separator: ",")
        
        let dialog_status = sendDataModel.dialogStatus == 2 ? [user.id : sendDataModel.dialogStatus, otherUserId: sendDataModel.dialogStatus] : [user.id : sendDataModel.dialogStatus, otherUserId: 4]
        
        let user_name = [user.id: "\(user.firstName) \(user.lastName )", otherUserId: sendDataModel.userName]
        let user_id = [user.id: user.id, otherUserId: otherUserId]

        var user_pic = [otherUserId: sendDataModel.userPic ?? "dp"]
        //Get loggedin user's pic
        let images = user.userImages.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
        if !images.isEmpty {
            let foundImage = images.first
            user_pic[user.id] = foundImage?.file ?? "dp"
        } else {
            user_pic[user.id] = "dp"
        }
        
        let createDate = Int64(Date().timeIntervalSince1970 * 1000)
        let unread_count = [user.id: 0, otherUserId: 0]
        let block_status = [user.id: 0, otherUserId: 0]
        let last_message = [user.id: lastMessageRegex, otherUserId: lastMessageRegex]
        
        let premium_status = [user.id: user.isSubscriptionPlanActive, otherUserId: sendDataModel.isSubscriptionPlanActive ?? 0]
        let clear_chat_time = [user.id: createDate, otherUserId: createDate]
        
        let is_connection = [user.id: sendDataModel.isConnection ?? 0, otherUserId: sendDataModel.isConnection ?? 0]
        let message_count = [user.id: 0, otherUserId: 0]
        let message_length = [user.id: 0, otherUserId: 0]
        let gift_date = [user.id: Int64(0), otherUserId: Int64(0)]
        let message_date = [user.id: Int64(0), otherUserId: Int64(0)]
        let message_sent = [user.id: 0, otherUserId: 0]
        let creation_date = [user.id: Int64(0), otherUserId: Int64(0)]
        
        let user_number = [user.id: "\(user.firstName) \(user.lastName )", otherUserId: (sendDataModel.isPhoneVerified == 0 ? "\(sendDataModel.countryCode ?? "")\(sendDataModel.phoneNumber ?? "")" : sendDataModel.userName ?? "")]
        
        let chatRoom = ChatRoomModel(chat_dialog_id: chatDialogId, name: "", pic: "", dialog_type: 1, dialog_status: dialog_status, dialog_admin: user.id, last_message_id: "", last_message_sender_name: "", last_message_sender_id: "", last_message: last_message, last_message_type: 0, last_message_time: createDate, user_id: user_id, user_name: user_name, user_pic: user_pic, clear_chat_time: clear_chat_time, dialog_create_time: createDate, unread_count: unread_count, block_status: block_status, premium_status: premium_status, dialog_conversation: 0, is_connection: is_connection, message_count: message_count, message_length: message_length, message_sent: message_sent, gift_date: gift_date, message_date: message_date, creation_date: creation_date, user_number: user_number)
        
        //Save data in Users table
        updateUsersTable(userId: user.id, chatDialogId: chatDialogId)
        updateUsersTable(userId: otherUserId, chatDialogId: chatDialogId)

        //Save data in Chats table
        ref.child("Chats").child(chatDialogId).setValue([
            "chat_dialog_id": chatDialogId,
            "name": "",
            "pic": "dp",
            "dialog_type": 1,
            "dialog_status": dialog_status,
            "dialog_admin": user.id,
            "last_message": last_message,
            "last_message_time": createDate,
            "last_message_id": "",
            "last_message_type": 0,
            "last_message_sender_name" : "",
            "last_message_sender_id" : "",
            "user_id" : user_id,
            "user_name" : user_name,
            "user_pic" : user_pic,
            
            "clear_chat_time" : clear_chat_time,
            "dialog_create_time" : createDate,
            "unread_count" : unread_count,
            "block_status" : block_status,
            "premium_status" : premium_status,
            "dialog_conversation": 0,
            
            "is_connection": is_connection,
            "message_count": message_count,
            "message_length": message_length,
            "gift_date": gift_date,
            "message_date" : message_date,
            "message_sent": message_sent,
            "creation_date": creation_date,
            "user_number": user_number
        ])
        return chatRoom
    }
    
    static func createGroupChatRoom(name: String, chatDialogId: String, groupMemberList: [[String: Any]],isNeedToSendLastMessgaeId: Bool = false) -> ChatRoomModel {
        let ref = Database.database().reference()
        let user = UserModel.shared.user
        
        var dialog_status: [String: Int] = [:]
        var user_id: [String: String] = [:]
        var user_name: [String: String] = [:]
        var user_pic: [String: String] = [:]
        var unread_count: [String: Int] = [:]
        var block_status: [String: Int] = [:]
        var last_message: [String: String] = [:]
        var premium_status: [String: Int] = [:]
        var clear_chat_time: [String: Int64] = [:]
        var is_connection: [String: Int] = [:]
        var message_count: [String: Int] = [:]
        var message_length: [String: Int] = [:]
        var gift_date: [String: Int64] = [:]
        var message_date: [String: Int64] = [:]
        var message_sent: [String: Int] = [:]
        var creation_date: [String: Int64] = [:]
        var user_number: [String: String] = [:]
        
        // This need to added because when we create group (share controller in that we have create gr)
        var lastMesgeId = ""
        if isNeedToSendLastMessgaeId{
            lastMesgeId = "groupSend"
        }

        let createDate = Int64(Date().timeIntervalSince1970 * 1000)
        for dict in groupMemberList {
            if let userId = dict["userId"] as? String, userId != "<null>" && userId != "" {
                
                dialog_status[userId] = 3
                user_id[userId] = userId

                let isPhoneVerified = dict["isPhoneVerified"] as? Int ?? 0
                if isPhoneVerified == 1 { //App User
                    let firstName = dict["firstName"] as? String ?? ""
                    let lastName = dict["lastName"] as? String ?? ""
                    user_name[userId] = firstName + " " + lastName

                } else {
                    user_name[userId] = dict["name"] as? String ?? ""
                }
                
                let dp = dict["dp"] as? String ?? ""
                user_pic[userId] = dp == "" ? "dp" : dp
                
                unread_count[userId] = 0
                
                block_status[userId] = 0
                
                last_message[userId] = lastMessageRegex
                
                if isPhoneVerified == 1 { //App User
                    premium_status[userId] = dict["isSubscriptionPlanActive"] as? Int ?? 0

                } else {
                    premium_status[userId] = 0
                }
                
                clear_chat_time[userId] = createDate

                is_connection[userId] = 1

                message_count[userId] = 0

                message_length[userId] = 0

                gift_date[userId] = Int64(0)

                message_date[userId] = Int64(0)

                message_sent[userId] = 0

                creation_date[userId] = Int64(0)

                let countryCode = dict["countryCode"] as? String ?? ""
                let number = "\(dict["number"] ?? 0)"
                user_number[userId] = countryCode + number
                
                updateUsersTable(userId: userId, chatDialogId: chatDialogId)
            }
        }
              
        dialog_status[user.id] = 3
        user_id[user.id] = user.id
        user_name[user.id] = "\(user.firstName) \(user.lastName )"
        
        //Get loggedin user's pic
        let images = user.userImages.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
        if !images.isEmpty {
            let foundImage = images.first
            user_pic[user.id] = foundImage?.file ?? "dp"
        } else {
            user_pic[user.id] = "dp"
        }
        
        //Add all values for admin
        unread_count[user.id] = 0
        block_status[user.id] = 0
        last_message[user.id] = lastMessageRegex
        premium_status[user.id] = user.isSubscriptionPlanActive
        clear_chat_time[user.id] = createDate
        is_connection[user.id] = 1
        message_count[user.id] = 0
        message_length[user.id] = 0
        gift_date[user.id] = Int64(0)
        message_date[user.id] = Int64(0)
        message_sent[user.id] = 0
        creation_date[user.id] = Int64(0)
        user_number[user.id] = user.countryCode + user.phoneNumber

        
        //Save data in Chats table
        ref.child("Chats").child(chatDialogId).setValue([
            "chat_dialog_id": chatDialogId,
            "name": name,
            "pic": "dp",
            "dialog_type": 2,
            "dialog_status": dialog_status,
            "dialog_admin": user.id,
            "last_message": last_message,
            "last_message_time": createDate,
            "last_message_id": lastMesgeId,
            "last_message_type": 0,
            "last_message_sender_name" : "",
            "last_message_sender_id" : "",
            "user_id" : user_id,
            "user_name" : user_name,
            "user_pic" : user_pic,
            
            "clear_chat_time" : clear_chat_time,
            "dialog_create_time" : createDate,
            "unread_count" : unread_count,
            "block_status" : block_status,
            "premium_status" : premium_status,
            "dialog_conversation": 0,
            
            "is_connection": is_connection,
            "message_count": message_count,
            "message_length": message_length,
            "gift_date": gift_date,
            "message_date": message_date,
            "message_sent": message_sent,
            "creation_date": creation_date,
            "user_number": user_number
        ])
        
        let chatRoom = ChatRoomModel(chat_dialog_id: chatDialogId, name: name, pic: "dp", dialog_type: 2, dialog_status: dialog_status, dialog_admin: user.id, last_message_id: lastMesgeId, last_message_sender_name: "", last_message_sender_id: "", last_message: last_message, last_message_type: 0, last_message_time: createDate, user_id: user_id,user_name: user_name, user_pic: user_pic, clear_chat_time: clear_chat_time, dialog_create_time: createDate, unread_count: unread_count, block_status: block_status, premium_status: premium_status, dialog_conversation: 0, is_connection: is_connection, message_count: message_count, message_length: message_length, message_sent: message_sent, gift_date: gift_date, message_date: message_date, creation_date: creation_date, user_number: user_number)
        
        return chatRoom
    }

    // MARK: - Update Chatroom
    static func updateLastMessageAndUnReadCount(chatRoom: ChatRoomModel?, message: MessageModel) {
        let ref = Database.database().reference()
        
        //Save data in Users table
        let senderName = chatRoom?.user_name?[message.sender_id ?? ""] ?? ""
        var last_message: [String: String]  = [:]
        for (key, _) in chatRoom?.user_id ?? [:] {
            last_message[key] = message.message_type == 2 ? "Image" : (message.message_type == 4 ? message.attachment_url : message.message ?? lastMessageRegex)
        }

        var unread_count: [String: Int]  = [:]
        for (key, value) in chatRoom?.unread_count ?? [:] {
            //Update 0 for me and +1 for others
            let lastCount = key == UserModel.shared.user.id ? 0 : value + 1
            unread_count[key] = lastCount
        }
        
        ref.child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
           // "user_name" : message.user_name ?? "",
            "last_message": last_message,
            "last_message_time": message.message_time ?? 0,
            "last_message_id": message.message_id ?? "",
            "last_message_type": message.message_type ??  0,
            "last_message_sender_name" : senderName,
            "last_message_sender_id" : message.sender_id ?? "",
            "unread_count" : unread_count,
            "message_count" : chatRoom?.message_count ?? [:],
            "message_length" : chatRoom?.message_length ?? [:],
            "message_date" : chatRoom?.message_date ?? [:],
            "message_sent": chatRoom?.message_sent ?? [:],
            "creation_date": chatRoom?.creation_date ?? [:]
        ])
    }
    
    static func updateUnReadCount(chatRoom: ChatRoomModel?) {
        let ref = Database.database().reference()
        
        var unread_count: [String: Int]  = [:]
        for (key, value) in chatRoom?.unread_count ?? [:] {
            //Update 0 for me and no change for others
            let lastCount = key == UserModel.shared.user.id ? 0 : value
            unread_count[key] = lastCount
        }
        
        ref.child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
            "unread_count" : unread_count,
        ])
    }
    
    static func updateDialogStatus(chatRoom: ChatRoomModel?) {
        let ref = Database.database().reference()
        var dialog_status: [String: Int]  = [:]
        for (key, _) in chatRoom?.dialog_status ?? [:] {
            dialog_status[key] = 2
        }
        
        ref.child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
            "dialog_status" : dialog_status,
        ])
    }
    
    static func blockUnblockUserOnFirebase(chat_dialog_id: String, param: [String: Any]) {
        let ref = Database.database().reference().child("Chats").child(chat_dialog_id)
        ref.child("block_status").updateChildValues(param)
    }
    
    static func updateGiftDateStatus(chatRoom: ChatRoomModel?, param: [String: Any]) {
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
            "gift_date": param,
            "message_count": chatRoom?.message_count ?? [:],
            "message_length": chatRoom?.message_length ?? [:],
            "message_date": chatRoom?.message_date ?? [:],
        ])
    }

    static func refillCredits(chatRoom: ChatRoomModel?) {
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
            "message_count": chatRoom?.message_count ?? [:],
            "message_length": chatRoom?.message_length ?? [:],
            "message_date": chatRoom?.message_date ?? [:],
        ])
    }
    
    static func upgradePremiumStatusOnFirebase(chatRoom: ChatRoomModel?) {
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").child("premium_status").updateChildValues([UserModel.shared.user.id: 1])
    }
    
    static func updateNewAdminStatusOnFirebase(chatRoom: ChatRoomModel?, newAdmin: String) {
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues(["dialog_admin": newAdmin])
    }
    
    static func uptadeUsernameOnFirebase(chatRoom: ChatRoomModel?) {
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues(["user_name": chatRoom?.user_name ?? [:], "user_number": chatRoom?.user_number ?? [:]])
    }
    
    // MARK: - Clear Chatroom
    static func clearMessagesOfChatRoom(chat_dialog_id: String) {
        let userId = UserModel.shared.user.id
        let createDate = Int64(Date().timeIntervalSince1970 * 1000)
        Database.database().reference().child("Chats").child(chat_dialog_id).child("clear_chat_time").updateChildValues([userId: createDate])
    }
    
    static func emptyLastMessageOnFirebase(chatRoom: ChatRoomModel?) {
        //Save data in Chats table
        var last_message = chatRoom?.last_message ?? [:]
        last_message[UserModel.shared.user.id] = lastMessageRegex
        
        Database.database().reference().child("Chats").child(chatRoom?.chat_dialog_id ?? "").updateChildValues([
            "last_message": last_message,
        ])
    }
    
    static func deleteChatOnFirebase(chatRoom: ChatRoomModel) {
        let ref = Database.database().reference()
        
        //Fetch all members then delete all from group and then delete group
        let chatDB = ref.child("Chats/\(chatRoom.chat_dialog_id ?? "")/user_id")
        chatDB.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                //Update Users table
                for item in snapDict {
                    ref.child("Users").child(item.key).child("chat_dialog_ids/\(chatRoom.chat_dialog_id ?? "")").removeValue{ error, _ in
                        print(error?.localizedDescription ?? "")
                    }
                }
            } else{
                print("SnapDict is null")
            }
            //Delete From Chats table
            ref.child("Chats").child(chatRoom.chat_dialog_id ?? "").removeValue { error, _ in
                print(error?.localizedDescription ?? "")
            }
            
            //Delete From Messages table
            ref.child("Messages").child(chatRoom.chat_dialog_id ?? "").removeValue { error, _ in
                print(error?.localizedDescription ?? "")
            }
        })
        FMDBDatabase.deleteAllMessagesOfGroup(chat_dialog_id: chatRoom.chat_dialog_id ?? "")
    }

    // MARK: - Update Users
    static func updateUsersTable(userId: String, chatDialogId: String) {
        let ref = Database.database().reference()
        let usersDB = ref.child("Users/\(userId)")
        usersDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                //User is already added in Users table then just update chat dialog id
                ref.child("Users").child(userId).child("chat_dialog_ids").updateChildValues([
                    chatDialogId: chatDialogId
                ])
                
            } else {
                //User is new then add in Users table
                ref.child("Users").child(userId).setValue([
                    "user_id" : userId,
                    "chat_dialog_ids": [
                        chatDialogId: chatDialogId
                    ]
                ])
            }
        })
    }
    
    static func updateUsersTableForNewMessage(user: UserDataModel) {
        let ref = Database.database().reference()
        ref.child("Users").child(UserModel.shared.user.id).updateChildValues([
            "message_date" : user.message_date ?? Int64(0),
            "message_dialog": user.message_dialog ?? [:],
            "dialog_count": user.dialog_count ?? 0
        ])
    }
    
    // MARK: - Send Message
    static func getMessageAutoId(chat_dialog_id: String) -> String? {
        let ref = Database.database().reference().child("Messages").child(chat_dialog_id).childByAutoId()
        let autoId = ref.key
        return autoId
    }
    
    static func sendMessageOnFirebase(message: MessageModel, chatRoom: ChatRoomModel) {
        //Save data in Messages table
        var dataToSend = [
         //   "user_name" : message.user_name ?? "",
            "message_id": message.message_id ?? "",
            "message": message.message ?? "",
            "message_type": message.message_type!,
            "message_time": message.message_time!,
            "firebase_message_time": message.firebase_message_time!,
            
            "chat_dialog_id": message.chat_dialog_id ?? "",
            "sender_id": message.sender_id ?? "",
            
            "attachment_url": message.attachment_url ?? "",
        ] as [String : Any]
        
        dataToSend["receiver_id"] = message.receiver_id ?? [:]
        
        dataToSend["reply_msg"] = message.reply_msg ?? ""
        dataToSend["reply_id"] = message.reply_id ?? ""
        dataToSend["reply_type"] = message.reply_type ?? 0
        dataToSend["reply_msg_id"] = message.reply_msg_id ?? ""
        
        Database.database().reference().child("Messages").child(message.chat_dialog_id ?? "").child(message.message_id ?? "").setValue(dataToSend)
        
        //Save data in Messages table
        dataToSend["groupName"] = chatRoom.dialog_type == 1 ? "" : chatRoom.name
        Database.database().reference().child("Notifications").child(message.message_id ?? "").setValue(dataToSend)
    }
            
    // MARK: - Group Operations
    static func leaveGroup(group: ChatRoomModel?, userId: String) {
        let ref = Database.database().reference()
        
        //Remove Chat dialog id for leaving member
        ref.child("Users").child(userId).child("chat_dialog_ids/\(group?.chat_dialog_id ?? "")").removeValue{ error, _ in
            print(error?.localizedDescription ?? "")
        }
        
        //Update Chats table
        var user_id = group?.user_id
        user_id?.removeValue(forKey: userId)
        
        var user_name = group?.user_name
        user_name?.removeValue(forKey: userId)

        var user_pic = group?.user_pic
        user_pic?.removeValue(forKey: userId)

        var dialog_status = group?.dialog_status
        dialog_status?.removeValue(forKey: userId)
        
        var unread_count = group?.unread_count
        unread_count?.removeValue(forKey: userId)
        
        var block_status = group?.block_status
        block_status?.removeValue(forKey: userId)

        var last_message = group?.last_message
        last_message?.removeValue(forKey: userId)
        
        var premium_status = group?.premium_status
        premium_status?.removeValue(forKey: userId)
        
        var clear_chat_time = group?.clear_chat_time
        clear_chat_time?.removeValue(forKey: userId)
        
        var is_connection = group?.is_connection
        is_connection?.removeValue(forKey: userId)
        
        var message_count = group?.message_count
        message_count?.removeValue(forKey: userId)
        
        var message_length = group?.message_length
        message_length?.removeValue(forKey: userId)
        
        var gift_date = group?.gift_date
        gift_date?.removeValue(forKey: userId)
      
        var message_date = group?.message_date
        message_date?.removeValue(forKey: userId)
        
        var message_sent = group?.message_sent
        message_sent?.removeValue(forKey: userId)
        
        var creation_date = group?.creation_date
        creation_date?.removeValue(forKey: userId)
        
        var user_number = group?.user_number
        user_number?.removeValue(forKey: userId)
        
        Database.database().reference().child("Chats").child(group?.chat_dialog_id ?? "").updateChildValues(["user_id": user_id ?? [:],
                                   "user_name": user_name ?? [:],
                                    "user_pic": user_pic ?? [:],
                                    "dialog_status": dialog_status ?? [:],
                                    "unread_count": unread_count ?? [:],
                                    "block_status": block_status ?? [:],
                                    "last_message": last_message ?? [:],
                                    "premium_status": premium_status ?? [:],
                                    "clear_chat_time": clear_chat_time ?? [:],
                                    "is_connection": is_connection ?? [:],
                                    "message_count": message_count ?? [:],
                                    "message_length": message_length ?? [:],
                                    "gift_date": gift_date ?? [:],
                                    "message_date": message_date ?? [:],
                                    "message_sent": message_sent ?? [:],
                                    "creation_date": creation_date ?? [:],
                                    "user_number": user_number ?? [:]])
        
        FMDBDatabase.deleteAllMessagesOfGroup(chat_dialog_id: group?.chat_dialog_id ?? "")
        
        //        ref.child("Chats").child(groupId).child("clear_chat_time/\(userId)").removeValue { error, _ in
        //            print(error?.localizedDescription ?? "")
        //        }
    }
    
    static func addMemberToGroup(group: ChatRoomModel?, dict: UserPhoneBookModel) {
        
        //Save data in Users table
        if let userId = dict.userId, userId != "<null>" && userId != "" {
            
            let usersRef = Database.database().reference().child("Users/\(userId)")
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    //User is already added in Users table then just update chat dialog id
                    usersRef.child("chat_dialog_ids").updateChildValues([group?.chat_dialog_id ?? "": group?.chat_dialog_id ?? ""])
                    
                } else {
                    //User is new then add in Users table
                    usersRef.setValue([
                        "user_id" : userId,
                        "chat_dialog_ids": [group?.chat_dialog_id ?? "": group?.chat_dialog_id ?? ""]
                    ])
                }
            })
            
            //Save data in Chats table
            let chatsRef = Database.database().reference().child("Chats").child(group?.chat_dialog_id ?? "")
            
            var user_id = group?.user_id
            user_id?[userId] = userId

            var user_name = group?.user_name
            let isPhoneVerified = dict.isPhoneVerified ?? 0
            var name: String?
            if isPhoneVerified == 1 { //App User
                let firstName = dict.firstName ?? ""
                let lastName = dict.lastName ?? ""
                name = firstName + " " + lastName

            } else {
                name = dict.name ?? ""
            }
            user_name?[userId] = name ?? ""
            
            var user_pic = group?.user_pic
            user_pic?[userId] = dict.dp ?? "dp"

            var dialog_status = group?.dialog_status
            dialog_status?[userId] = 3
            
            var unread_count = group?.unread_count
            unread_count?[userId] = 0
            
            var block_status = group?.block_status
            block_status?[userId] = 0
            
            var last_message = group?.last_message
            last_message?[userId] = lastMessageRegex
            
            var premium_status = group?.premium_status
            premium_status?[userId] = isPhoneVerified == 1 ? dict.isSubscriptionPlanActive ?? 0 : 0
            
            var clear_chat_time = group?.clear_chat_time
            let createDate = Int64(Date().timeIntervalSince1970 * 1000)
            clear_chat_time?[userId] = createDate
            
            var is_connection = group?.is_connection
            is_connection?[userId] = 1
            
            var message_count = group?.message_count
            message_count?[userId] = 0
            
            var message_length = group?.message_length
            message_length?[userId] = 0
            
            var gift_date = group?.gift_date
            gift_date?[userId] = Int64(0)
            
            var message_date = group?.message_date
            message_date?[userId] = Int64(0)

            var message_sent = group?.message_sent
            message_sent?[userId] = 0
            
            var creation_date = group?.creation_date
            creation_date?[userId] = Int64(0)
            
            var user_number = group?.user_number
            let countryCode = dict.countryCode ?? ""
            let number = "\(dict.number ?? "")"
            user_number?[userId] = countryCode + number

            chatsRef.updateChildValues(["user_id": user_id ?? [:],
                                        "user_name": user_name ?? [:],
                                        "user_pic": user_pic ?? [:],
                                        "dialog_status": dialog_status ?? [:],
                                        "unread_count": unread_count ?? [:],
                                        "block_status": block_status ?? [:],
                                        "last_message": last_message ?? [:],
                                        "premium_status": premium_status ?? [:],
                                        "clear_chat_time": clear_chat_time ?? [:],
                                        "is_connection": is_connection ?? [:],
                                        "message_count": message_count ?? [:],
                                        "message_length": message_length ?? [:],
                                        "gift_date": gift_date ?? [:],
                                        "message_date": message_date ?? [:],
                                        "message_sent": message_sent ?? [:],
                                        "creation_date": creation_date ?? [:],
                                        "user_number": user_number ?? [:]])
        }
    }
    
    static func updateGroupInfo(groupPic: String?, name: String?, groupId: String) {
        //Save data in Chats table
        let chatsRef = Database.database().reference().child("Chats").child(groupId)
        
        if name != nil {
            chatsRef.updateChildValues(["name": name!])
        }
        
        if groupPic != nil {
            chatsRef.updateChildValues(["pic": groupPic!])
        }
    }
}

struct FirebaseSendDataModel: Codable {
    let id: String?
    var dialogStatus: Int = 0
    var userName: String = ""
    let userPic: String?
    let isSubscriptionPlanActive: Int?
    let isConnection: Int?
    let countryCode: String?
    let phoneNumber: String?
    let isPhoneVerified: Int?
}
