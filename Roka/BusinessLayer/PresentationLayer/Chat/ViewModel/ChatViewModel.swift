//
//  ChatViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase
import Photos

class ChatViewModel: BaseViewModel {
    // Used this bool,becauae if user open the chat controller from home view controller but didn't chat so there is not need to add the other user in firebase data base.
    var isChatUserExist : Bool = true
    var isCome = ""
    var completionHandler: ((Bool) -> Void)?
    var chatRoom: ChatRoomModel?
    var replyMessageModel: MessageModel? = nil
    var userDataModel: UserDataModel?

    var otherUserId = ""

    var groupedByDate: [String: [MessageModel]] = [:]
    var sectionHeaders: [String] = []
    
    private var scrollView = UIScrollView()

    
    let ref = Database.database().reference().child("Messages")
    // MARK: -  Message Observers
    func fetchAllMessages(chat_dialog_id: String, handler: @escaping (() -> Void)) {
        FMDBDatabase.query(where: [WhereCondition(column: "chat_dialog_id", value: chat_dialog_id)]) { success, result, error in
            while result?.next() == true {
                if let dict = result?.resultDictionary {
                    do {
                        let model = try MessageModel.init(fromDB: dict)
                        
                        let date = self.getSectionDate(model: model)
                        if self.sectionHeaders.contains(date) {
                            if (!(self.groupedByDate[date]?.contains(where: {$0.message_id == model.message_id}) ?? !self.groupedByDate.isEmpty)) {
                                if self.groupedByDate.keys.contains(date) {
                                    self.groupedByDate[date]?.append(model)
                                } else {
                                    self.groupedByDate[date] = [model]
                                    self.sectionHeaders.append(date)
                                }
                            }
                        } else {
                            self.groupedByDate[date] = [model]
                            self.sectionHeaders.append(date)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
            handler()
        }
    }
    
    func observeIfAnyMessageAdded(handler: @escaping (() -> Void)) {
        ref.child(chatRoom?.chat_dialog_id ?? "").queryOrdered(byChild: "message_time").observe(.childAdded, with: { snapshot in
            
            if let snapDict = snapshot.value as? [String:AnyObject] {
                do {
                    let message = try MessageModel.init(dict: snapDict)
                    
                    if self.chatRoom?.clear_chat_time == nil || self.chatRoom?.clear_chat_time?.count == 0 || message.message_time ?? 0 >= self.chatRoom?.clear_chat_time?[UserModel.shared.user.id] ?? 0 {
                        
                        let date = self.getSectionDate(model: message)
                        if self.sectionHeaders.contains(date) {
                            if (!(self.groupedByDate[date]?.contains(where: {$0.message_id == message.message_id}) ?? !self.groupedByDate.isEmpty)) {
                                if self.groupedByDate.keys.contains(date) {
                                    self.groupedByDate[date]?.append(message)
                                } else {
                                    
                                    self.groupedByDate[date] = [message]
                                    self.sectionHeaders.append(date)
                                }
                                
                                //Save in DB as well
                                FMDBDatabase.insertMessage(message: message)
                                FirestoreManager.updateUnReadCount(chatRoom: self.chatRoom)
                                handler()
                            }
                        } else {
                            self.groupedByDate[date] = [message]
                            self.sectionHeaders.append(date)
                            
                            //Save in DB as well
                            FMDBDatabase.insertMessage(message: message)
                            FirestoreManager.updateUnReadCount(chatRoom: self.chatRoom)
                            handler()
                        }
                    }
                } catch let error {
                    print(error)
                }
            }else{
                print("SnapDict is null")
            }
        })
    }
    
    func observeIfChatRoomRemoved(handler: @escaping (() -> Void)) {
        Database.database().reference().child("Chats").queryOrderedByKey().queryEqual(toValue: self.chatRoom?.chat_dialog_id ?? "").observe(.childRemoved, with: { snapshot in
            
            if let _ = snapshot.value as? [String:AnyObject]{
                //If this room is deleted then pop
                handler()
            } else {
                print("SnapDict is null")
            }
        })
    }
    
    func observeIfChatRoomChanged(handler: @escaping ((ChatRoomModel?) -> Void)) {
        Database.database().reference().child("Chats").queryOrderedByKey().queryEqual(toValue: self.chatRoom?.chat_dialog_id ?? "").observe(.childChanged, with: { snapshot in

            if let snapDict = snapshot.value as? [String: Any]{
                do {
                    let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                    self.chatRoom = model
                    handler(model)
                    
                } catch let error {
                    print(error)
                }
                
            }else{
                print("SnapDict is null")
            }
        })
    }
    
    func fetchCurrentUser() {
        Database.database().reference().child("Users/\(UserModel.shared.user.id)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                do {
                    let user = try UserDataModel.init(dict: snapDict)
                    self.userDataModel = user
                    
                } catch let error {
                    print(error)
                }
            }
        })
    }
    
    func getSectionDate(model: MessageModel) -> String {
        let serverDate = Date(timeIntervalSince1970: TimeInterval((model.message_time ?? 0) / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "UTC")
        dateFormatter.doesRelativeDateFormatting = true
        let date = String(dateFormatter.string(from: serverDate))
        return date
    }
    
    func getMediaSectionDate(model: MessageModel) -> String {
        let serverDate = Date(timeIntervalSince1970: TimeInterval((model.message_time ?? 0) / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale(identifier: "UTC")
        let date = String(dateFormatter.string(from: serverDate))
        return date
    }
    
    func getScrollToIndexPath(reply_msg_id: String) -> IndexPath {
        var toSection = 0
        var toRow = 0
        for (key, value) in groupedByDate {
            if let foundIndex = value.firstIndex(where: {$0.message_id == reply_msg_id}) {
                toRow = foundIndex
                toSection = sectionHeaders.firstIndex(of: key) ?? 0
                break
            }
        }
        return IndexPath(row: toRow, section: toSection)
    }
    
    // MARK: -  APIs
    func clearChatApi(params: [String: Any],_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Chat.clearChat,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                result(responseData)
            }
            hideLoader()
        }
    }
    
    func blockUnblockApi(status: Int, _ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        let params: [String: String] = [WebConstants.profileId: otherUserId]
        
        ApiManager.makeApiCall(status == 0 ? APIUrl.UserApis.blockUser : APIUrl.UserApis.unblockUser,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                result(responseData)

                showSuccessMessage(with: status == 0 ? StringConstants.BlockSuccess : StringConstants.unBlockSuccess)
            }
            hideLoader()
        }
    }
    
    func getProfile(_ result:@escaping(ProfilesModel?) -> Void) {
        let param = [ "id": otherUserId] as [String: Any]
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserMatchMaking.getUserMatchMakingProfileData,
                                                                 params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
               
            } else if resultModel?.statusCode == 200 {
                result((resultModel?.data ?? []).first)
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    func processForLikeProfileData(isLiked: Int) {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.profileId] = otherUserId
        params[WebConstants.isLiked] = isLiked
        
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                if isLiked == 1 { //Like
                    FirestoreManager.updateDialogStatus(chatRoom: self.chatRoom!)

                } else { //Unlike
                    FirestoreManager.deleteChatOnFirebase(chatRoom: self.chatRoom!)
                }
            }
            hideLoader()
        }
    }
    
    func fetchOtherUserId() {
        for (key, _) in chatRoom?.user_id ?? [:] {
            if key != UserModel.shared.user.id { //Other User
                otherUserId = key
                break
            }
        }
    }
    
    // 1 - Group or connection or Under the limit can send message -> don't restrict
    // 2 - message_length will increase with this sending message -> restrict
    // 3 - Limit exhausted, No quota refill after 24 hours -> restrict
    // 4 - Limit exhausted, quota refill chat tomorrow -> restrict
    func checkForLimitToSendChatMessage(messageCount: Int) -> Int {
        if chatRoom?.dialog_type == 1 && chatRoom?.is_connection?[UserModel.shared.user.id] == 0 {
            //One to one chat and not connection
            
            if chatRoom?.premium_status?[UserModel.shared.user.id] == 0 && !checkIfGiftKeyValid() {
                //If the user is a Freemium Member and no gift key available
                
                let message_length = chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 150 : 100
                let message_count = chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 5 : 3
                
                //5 People check
                let (dayIsOver, _) = checkIfDayIsOver(message_date: chatRoom?.creation_date?[UserModel.shared.user.id] ?? 0)
                if dayIsOver {
                    //If day is over and you have chatted with this user yesterday then restrict.
                    return 4

                } else {
                    //same day
                    let (canRefill, _) = checkIfDayIsOver(message_date: userDataModel?.message_date ?? 0)
                    if canRefill {
                        //If day is over then Update dialog count, user can message to 5 new people
                        userDataModel?.dialog_count = 0

                    } else {
                        if userDataModel?.dialog_count == 5  {
                            //Daily Quota of 5 people is reached
                            let keyExists = self.userDataModel?.message_dialog?[chatRoom?.chat_dialog_id ?? ""] != nil
                            if !keyExists {
                                //You have not chatted with this user, and Already messaged 5 people today
                                return 4
                            }
                        }
                    }
                }
                
                if chatRoom?.message_length?[UserModel.shared.user.id] ?? 0 < message_length && chatRoom?.message_count?[UserModel.shared.user.id] ?? 0 < message_count {
                    //check if message_length will increase with this sending message
                    let sent_message_length = chatRoom?.message_length?[UserModel.shared.user.id] ?? 0
                    if messageCount > message_length - sent_message_length {
                        return 2

                    } else {
                        //Sending message then refill credits for other member.
                        if chatRoom?.message_sent?[otherUserId ] == 1 && chatRoom?.last_message_sender_id == otherUserId {
                            chatRoom?.message_count?[otherUserId] = message_count
                            chatRoom?.message_length?[otherUserId] = message_length
                            
                            let currentDateWithoutTime = getDateWithoutTime(date:  Date())
                            let currentDate = Int64(currentDateWithoutTime.timeIntervalSince1970 * 1000)
                            chatRoom?.message_date?[otherUserId] = currentDate
                            
                            FirestoreManager.refillCredits(chatRoom: chatRoom)
                        }
                        return 1
                    }
                    
                } else {
                    //Character or messaging limit is exhausted, No quota refill after 24 hours
                    return 3
                }
                
            } else { //If the user is a Premium Member
                let message_length = chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 250 : 150
                let message_count = chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 10 : 5

                if chatRoom?.message_length?[UserModel.shared.user.id] ?? 0 < message_length && chatRoom?.message_count?[UserModel.shared.user.id] ?? 0 < message_count {
                    //check if message_length will increase with this sending message
                    let sent_message_length = chatRoom?.message_length?[UserModel.shared.user.id] ?? 0
                    if messageCount > message_length - sent_message_length {
                        return 2

                    } else {
                        //Sending message then refill credits for other member.
                        chatRoom?.message_count?[otherUserId] = 0
                        chatRoom?.message_length?[otherUserId] = 0
                        
                        let currentDateWithoutTime = getDateWithoutTime(date:  Date())
                        let currentDate = Int64(currentDateWithoutTime.timeIntervalSince1970 * 1000)
                        chatRoom?.message_date?[otherUserId] = currentDate
                        
                        FirestoreManager.refillCredits(chatRoom: chatRoom)

                        return 1
                    }

                } else {
                    let (canRefill, date) = checkIfDayIsOver(message_date: chatRoom?.message_date?[UserModel.shared.user.id] ?? 0)
                    if canRefill {
                        //Day is over then refill credits for case of premium member only
                        chatRoom?.message_count = [UserModel.shared.user.id: 0, otherUserId: 0]
                        chatRoom?.message_length = [UserModel.shared.user.id: 0, otherUserId: 0]
                        chatRoom?.message_date = [UserModel.shared.user.id: date, otherUserId: date]
                        FirestoreManager.refillCredits(chatRoom: chatRoom)

                        return 1
                        
                    } else {
                        //Character or messaging limit is exhausted, chat again tomorrow
                        return 4

                    }
                }
            }
        } else {
            // Don't limit in case of group & connection
            return 1
        }
    }
    
 
    func checkIfGiftKeyValid() -> Bool {
        let giftKeyDate = chatRoom?.gift_date?[UserModel.shared.user.id] ?? 0
        if giftKeyDate != 0 {
                        
            let giftKeyDateWithoutTime = getDateWithoutTime(date:  Date(timeIntervalSince1970: TimeInterval(giftKeyDate / 1000)))
            let currentDateWithoutTime = getDateWithoutTime(date:  Date())
            
            let delta = currentDateWithoutTime.timeIntervalSince(giftKeyDateWithoutTime)
            //7 days check
            return delta <= 604800 ? true : false
        } else {
            return false
        }
    }
    
    func checkIfDayIsOver(message_date: Int64) -> (Bool, Int64) {
        if message_date == 0 {
            return (false, Int64(0))

        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd-MM-YYYY"
            
            let message_date_without_time = getDateWithoutTime(date:  Date(timeIntervalSince1970: TimeInterval(message_date / 1000)))
            let currentDateWithoutTime = getDateWithoutTime(date:  Date())
            
            if currentDateWithoutTime > message_date_without_time {
                let currentDate = Int64(currentDateWithoutTime.timeIntervalSince1970 * 1000)
                return (true, currentDate)
                
            } else {
                return (false, Int64(0))
            }
        }
    }

    func readyTheMessageToSend(message: String, uploadUrl: String, message_type: Int) -> String {
        let createDate = Int64(Date().timeIntervalSince1970 * 1000)
        let autoId = FirestoreManager.getMessageAutoId(chat_dialog_id: chatRoom?.chat_dialog_id ?? "")
        var receiver_id: [String: String] = [:]
        
        chatRoom?.user_id?.keys.forEach({ user_id in
            receiver_id[user_id] = user_id
        })
        
        var message = MessageModel(message_id: autoId, message: message, message_type: message_type, message_time: createDate, firebase_message_time: createDate, chat_dialog_id: chatRoom?.chat_dialog_id ?? "", sender_id: UserModel.shared.user.id, attachment_url: uploadUrl, receiver_id: receiver_id, reply_msg: "", reply_id: "", reply_type: 0, reply_msg_id: "")
        
        if let replyMsgModel = self.replyMessageModel {
            message.reply_id = replyMsgModel.sender_id
            message.reply_msg = replyMsgModel.message_type! == 1 || message.message_type! == 3 ||  message.message_type! == 5 ? (replyMsgModel.message ?? "") : replyMsgModel.attachment_url ?? ""
            message.reply_type = replyMsgModel.message_type
            message.reply_msg_id = replyMsgModel.message_id
        }
        
        FMDBDatabase.insertMessage(message: message)
        
        //Add the message to the messages array and reload it
        let date = getSectionDate(model: message)
        if self.groupedByDate.keys.contains(date) {
            self.groupedByDate[date]?.append(message)
        } else {
            self.groupedByDate[date] = [message]
            self.sectionHeaders.append(date)
        }
        
        let dateWithoutTime = getDateWithoutTime(date: Date())
        let message_date = Int64(dateWithoutTime.timeIntervalSince1970 * 1000)
        
        if message_type != 4 && message_type != 5 && chatRoom?.dialog_type == 1 {
            //Update count and length to apply messaging limit
            var message_length = chatRoom?.message_length?[UserModel.shared.user.id] ?? 0
            message_length = message_length + (message_type == 1 || message_type == 3 ? (message.message?.count ?? 0) : 50)
            chatRoom?.message_length?[UserModel.shared.user.id] = message_length
            
            let message_count = (chatRoom?.message_count?[UserModel.shared.user.id] ?? 0) + 1
            chatRoom?.message_count?[UserModel.shared.user.id] = message_count
            
            if chatRoom?.premium_status?[UserModel.shared.user.id] == 1 {
                //Premium case, refill credits for reciever
                chatRoom?.message_count?[otherUserId] = 0
                chatRoom?.message_length?[otherUserId] = 0
            }
           
            
            
            chatRoom?.message_date = [UserModel.shared.user.id: message_date, otherUserId: message_date]
            chatRoom?.message_sent?[UserModel.shared.user.id] = 1
            
            if self.chatRoom?.creation_date?[UserModel.shared.user.id] == 0 {
                chatRoom?.creation_date?[UserModel.shared.user.id] = message_date
            }
        }

        FirestoreManager.sendMessageOnFirebase(message: message, chatRoom: chatRoom!)
        FirestoreManager.updateLastMessageAndUnReadCount(chatRoom: chatRoom, message: message)
        
        if (self.userDataModel != nil) {
            let dateWithoutTimeForUser = getDateWithoutTime(date: Date())
            let message_date_user = Int64(dateWithoutTimeForUser.timeIntervalSince1970 * 1000)
            self.userDataModel?.message_date = message_date_user
            
            let chat_dialog_id = chatRoom?.chat_dialog_id ?? ""
            let keyExists = self.userDataModel?.message_dialog?[chat_dialog_id] != nil
            if !keyExists {
                let dialog_count = self.userDataModel?.dialog_count == nil ? 0 : (self.userDataModel?.dialog_count ?? 0)
                self.userDataModel?.dialog_count =  dialog_count + 1
            }

            if self.userDataModel?.message_dialog == nil {
                userDataModel?.message_dialog = [chat_dialog_id: chat_dialog_id]
            } else {
                userDataModel?.message_dialog?[chat_dialog_id] = chat_dialog_id
            }
            
            FirestoreManager.updateUsersTableForNewMessage(user: self.userDataModel!)
        }
        return date
    }
    
    func getDateWithoutTime(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateStr = dateFormatter.string(from: date)
        
        let dateWithoutTime = dateFormatter.date(from: dateStr)
        return dateWithoutTime!
    }
    
    // MARK: -  Image Picker
    func checkForCamera(handler: @escaping ((MediaAction) -> Void)) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3)) {
                let status  = AVCaptureDevice.authorizationStatus(for: .video)
                if status == .authorized {
                    handler(.cameraSuccess)
                    
                } else if status == .notDetermined {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                        if status == true {
                            handler(.cameraSuccess)
                        } else {
                            handler(.permissionError)
                        }
                    })
                } else if status == .restricted || status == .denied {
                    handler(.permissionError)
                }
            }
        } else {
            handler(.cameraNotFound)
        }
    }
    
    func checkForGalleryAction(handler: @escaping ((MediaAction) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if(status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    handler(.gallerySuccess)
                } else {
                    handler(.permissionError)
                }
            })
        } else if (status == .authorized) {
            handler(.gallerySuccess)
        } else if (status == .restricted || status == .denied) {
            handler(.permissionError)
        }
    }
    
    func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    // Helper function inserted by Swift 4.2 migrator.
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    // Helper function inserted by Swift 4.2 migrator.
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    func urlExists(_ input: String) -> (Bool, String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = input[range]
            return (true, String(url))
        }
        return (false, "")
    }
    
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<UploadUrlResponseModel>.makeApiCall(APIUrl.BasicApis.uploadImage,
                                                                  params: params,
                                                                  headers: headers,
                                                                  method: .post) { (response, model) in
            //            DispatchQueue.main.async {
            //                hideLoader()
            //            }
            if model?.statusCode == 200 {
                result(model)
            } else {
                DispatchQueue.main.async {
                    hideLoader()
                    showMessage(with: response?["message"] as? String ?? "")
                }
            }
        }
    }
    
    func verifyImage(params: [String: Any],_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.imageModulation,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                result(responseData)
            }
            hideLoader()
        }
    }
    
    func uploadImage(_ imgURL: String, image: UIImage, _ result:@escaping(String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        let url = URL(string: imgURL)
        var request: NSMutableURLRequest? = nil
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }
        request?.httpBody = imageData
       // request?.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        request?.setValue("image/png", forHTTPHeaderField: "Content-Type")
        request?.httpMethod = "PUT"
        let session = URLSession.shared
        let task1 = session.uploadTask(with: request! as URLRequest, from: imageData) { _ , response, error in
            DispatchQueue.main.async {
                Progress.instance.hide()
                hideLoader()
                
            }
            error == nil ? result("success") : result("failure")
        }
        task1.resume()
    }
    
    func proceedForChatPager() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
    }
    
    func openPreviewController(images: [LightboxImage], selectedIndex : Int){
        let controller = LightboxController(images: images, startIndex: selectedIndex)
        controller.dynamicBackground = true
        KAPPSTORAGE.isLightBoxOpenForChat = "yes"
        self.hostViewController.present(controller, animated: true, completion: nil)
    }
    
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        return arr
    }
}

enum MediaAction: Int {
    case cameraSuccess = 0
    case gallerySuccess
    case cameraNotFound
    case permissionError
}


extension ChatViewModel {
    
}
