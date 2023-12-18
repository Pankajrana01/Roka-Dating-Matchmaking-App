//
//  ChatInviteViewModel.swift
//  Roka
//
//  Created by Applify  on 20/12/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase

class ChatInviteViewModel: BaseViewModel {
    var isChatComes : Bool = false
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    
    var chatRooms: [ChatRoomModel] = [];
    var searchListArray = [ChatRoomModel]()
    var searchedText = "";

    var initialDataLoaded = false;
    
    let ref = Database.database().reference().child("Chats")
        .queryOrdered(byChild: "user_id/\(UserModel.shared.user.id)").queryEqual(toValue: UserModel.shared.user.id)
    
    func fetchAllChats(handler: @escaping (() -> Void)) {
        ref.observeSingleEvent(of: .value, with: { [self](snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                for item in snapDict {
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: item.value)
                        if model.dialog_status?[UserModel.shared.user.id] == 4 {
                            self.chatRooms.append(model)
                        }
                    } catch let error {
                        print(error)
                    }
                }
                
                self.chatRooms = self.chatRooms.sorted(by: {$0.last_message_time ?? 0 > $1.last_message_time ?? 0})
                handler()
                
            } else {
                print("SnapDict is null")
            }
        
            self.initialDataLoaded = true;
        })
    }
    
    func observeIfChatRoomAdded(handler: @escaping (() -> Void)) {
        ref.observe(.childChanged, with: { snapshot in
            
            if (self.initialDataLoaded) {
                
                if let snapDict = snapshot.value as? [String:AnyObject] {
                    
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                        let index = self.chatRooms.firstIndex{ $0.chat_dialog_id == model.chat_dialog_id }
                        if index == nil && model.dialog_status?[UserModel.shared.user.id] == 4 {
                            self.chatRooms.insert(model, at: 0)
                        }
                    } catch let error {
                        print(error)
                    }
                    
                } else {
                    print("SnapDict is null")
                }
                handler()
            }
        })
    }
    
    func observeIfChatRoomChanged(handler: @escaping (() -> Void)) {
        ref.observe(.childChanged, with: { snapshot in

            if let snapDict = snapshot.value as? [String: Any]{
                let chat_dialog_id = snapDict["chat_dialog_id"] as? String

                do {
                    let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                    self.chatRooms = self.chatRooms.map { room in
                        room.chat_dialog_id == chat_dialog_id ? model : room
                    }
                    
                    //Status changed then remove from invite and move it to inbox
                    self.chatRooms.removeAll(where: {$0.dialog_status?[UserModel.shared.user.id] != 4 })
                    
                } catch let error {
                    print(error)
                }
                self.chatRooms = self.chatRooms.sorted(by: {$0.last_message_time ?? 0 > $1.last_message_time ?? 0})

            }else{
                print("SnapDict is null")
            }
            handler()
        })
    }

    func observeIfChatRoomRemoved(handler: @escaping (() -> Void)) {
        ref.observe(.childRemoved, with: { snapshot in

            if let snapDict = snapshot.value as? [String:AnyObject]{
                let chat_dialog_id = snapDict["chat_dialog_id"]
                self.chatRooms.removeAll{$0.chat_dialog_id == chat_dialog_id as? String}
                FMDBDatabase.deleteAllMessagesOfGroup(chat_dialog_id: chat_dialog_id as! String)

            }else{
                print("SnapDict is null")
            }
            handler()
        })
    }
    
    func searchAction(text: String, handler: @escaping (() -> Void)) {
        searchedText = text
                
        if text == "" {
            searchListArray.removeAll()
        } else {
            searchListArray = chatRooms.filter({ (value) -> Bool in
                let roomName = getChatDialogName(value: value)
                return ((value.name ?? "").lowercased()).contains(text.lowercased()) || (roomName.lowercased()).contains(text.lowercased())
            })
        }
        handler()
    }
    
    func getChatDialogName(value: ChatRoomModel) -> String {
        var roomName = ""
        if value.dialog_type == 1 { //For one to one chat
            var otherUserKey = ""
            for (key, _) in value.user_id ?? [:] {
                if key != UserModel.shared.user.id { //Other User
                    otherUserKey = key
                    break
                }
            }
            
            if otherUserKey != "" {
                roomName = UserModel.shared.user.id == value.dialog_admin ? value.user_name?[otherUserKey] ?? "" : value.user_number?[otherUserKey] ?? ""
            }
        } else { //Group Chat
            roomName = value.name ?? ""
        }
        
        return roomName
    }
    
    func processForLikeProfileData(id: String, isLiked: Int, model: ChatRoomModel) {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.profileId] = id
        params[WebConstants.isLiked] = isLiked
        
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                if isLiked == 1 { //Like
                    FirestoreManager.updateDialogStatus(chatRoom: model)

                } else { //Unlike
                    FirestoreManager.deleteChatOnFirebase(chatRoom: model)
                }
            }
            hideLoader()
        }
    }

}
