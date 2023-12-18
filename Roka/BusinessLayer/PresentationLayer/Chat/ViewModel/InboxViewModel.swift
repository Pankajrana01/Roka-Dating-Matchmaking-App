//
//  InboxViewModel.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase

class InboxViewModel: BaseViewModel {
    
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    
    var chatRooms: [ChatRoomModel] = [];
    var filteredChatRooms: [ChatRoomModel] = [];
    var searchListArray = [ChatRoomModel]()
    
    var dataFilterStatus = "All";
    var searchedText = "";
    
    var initialDataLoaded = false;
    
    let ref = Database.database().reference().child("Chats")
        .queryOrdered(byChild: "user_id/\(UserModel.shared.user.id)").queryEqual(toValue: UserModel.shared.user.id)
    
    func fetchAllChats(handler: @escaping (() -> Void)) {
        showLoader()
        ref.observeSingleEvent(of: .value, with: { [self](snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                for item in snapDict {
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: item.value)
                        if model.dialog_status?[UserModel.shared.user.id] != 4 {
                            self.chatRooms.insert(model, at: 0)
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
            hideLoader()
        })
    }
    
    func observeIfChatRoomAdded(handler: @escaping (() -> Void)) {
        ref.observe(.childAdded, with: { snapshot in
            
            if (self.initialDataLoaded) {
                if let snapDict = snapshot.value as? [String:AnyObject] {
                    
                    do {
                        let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                        let index = self.chatRooms.firstIndex{ $0.chat_dialog_id == model.chat_dialog_id }
                        if index == nil && model.dialog_status?[UserModel.shared.user.id] != 4 {
                            self.chatRooms.append(model)
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
                    
                    //Find if dialog doesn't exist in chat rooms
                    let results = self.chatRooms.filter { $0.chat_dialog_id == chat_dialog_id }
                    if (results.isEmpty && model.dialog_status?[UserModel.shared.user.id] != 4) {
                        self.chatRooms.append(model)
                    }
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
    
    func applyFilters(handler: @escaping (() -> Void)) {
        //firebase status (0 for All, 1 for liked, 2 for matched, 3 for contact, 4 for other)
        if dataFilterStatus == "All" {
            filteredChatRooms.removeAll()
        } else {
            // group = 4
            // all 0
            //Aligned = 2
            // conatct = 3
            // liked = 1
            // not align = 5
            // other = 6
          //  self.arrFilters = ["All","Not Aligned", "Aligned", "Liked", "Groups", "Contact","Others"]
          //  self.arrFilters = ["All", "Aligned", "Liked", "Groups", "Contact"]
            let status = dataFilterStatus == "All" ? 0 : dataFilterStatus == "Aligned" ? 2 : dataFilterStatus == "Contact" ? 3 : dataFilterStatus == "Not Aligned" ? 5 : dataFilterStatus == "Liked" ? 1 : dataFilterStatus == "Groups" ? 4 : 6
            if status == 4{
                filteredChatRooms = chatRooms.filter({ $0.dialog_type == 2})
            }else{
                filteredChatRooms = chatRooms.filter({$0.dialog_status?[UserModel.shared.user.id] == status})
            }
        }
        handler()
    }
    
    func searchAction(text: String, handler: @escaping (() -> Void)) {
        searchedText = text
        
        if text == "" {
            searchListArray.removeAll()
        } else {
            if dataFilterStatus == "All" {
                searchListArray = chatRooms.filter({ (value) -> Bool in
                    let roomName = getChatDialogName(value: value)
                    return ((value.name ?? "").lowercased()).contains(text.lowercased()) || (roomName.lowercased()).contains(text.lowercased())
                })
            } else {
                searchListArray = filteredChatRooms.filter({ (value) -> Bool in
                    let roomName = getChatDialogName(value: value)
                    return ((value.name ?? "").lowercased()).contains(text.lowercased()) || (roomName.lowercased()).contains(text.lowercased())
                })
            }
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
}
