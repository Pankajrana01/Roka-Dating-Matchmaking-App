//
//  ShareViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

class shareTableViewCell: UITableViewCell{
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
}

class ShareViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((String) -> Void)?
    
    var profiles = [ProfilesModel]()
    var phonelists:[UserPhoneBookModel] = []
    var sharedIds = [String]()

    var fliterPhonelists:[UserPhoneBookModel] = []
    var contactsVM = ContactsViewModel()
    weak var tableView: UITableView! { didSet { configureTableView() } }
    weak var txtField: UITextField! { didSet { configureTextField() } }

    var shareIdValue = [Int]()
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureTextField() {
        txtField.delegate = self
        txtField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    
    // MARK: - API Call...
    func processForUpdateUserContactsData(_ result:@escaping(String?) -> Void) {
        var parms = [String:Any]()
        parms[WebConstants.numberList] = contactsVM.numberListDictionary
        DispatchQueue.main.async {
            showProgressLoader(text: "Loading contacts...")
        }
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<UserPhoneBookListModel>.makeApiCall(APIUrl.UserApis.userPhoneBookListV2,
                                                                  params: parms,
                                                                  headers: headers,
                                                                  method: .post) { (response, resultModel) in
            hideLoader()
            if !self.hasErrorIn(response) {
                self.phonelists.removeAll()
                let dataArr = resultModel?.data ?? []
                let newArray = dataArr.reduce(into: [UserPhoneBookModel]()) { result, model in
                    if !result.contains(where: { $0.number == model.number }) {
                        result.append(model)
                    }
                }
                self.phonelists = newArray
                print(self.phonelists)
                self.fliterPhonelists.append(contentsOf: self.phonelists)
                result("success")
                print(self.fliterPhonelists)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - API Call...
    func processForBlockContactData(parms:[String:Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.blockContacts,
                               params: parms,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let _ = response![APIConstants.data] as? [String: Any]{
                                        showSuccessMessage(with: StringConstants.blockUsersSuccess)
                                        self.processForUpdateUserContactsData { results in }
                                    }
                                }
                hideLoader()
        }
    }
    
    func getProfile(id: String, completionHandler: @escaping ((ProfilesModel?) -> Void)) {
        let param = [ "id": id] as [String: Any]
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserMatchMaking.getUserMatchMakingProfileData,
                                                                 params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
               
            } else if resultModel?.statusCode == 200 {
                if let modelArr = resultModel?.data, let model = modelArr.first {
                    completionHandler(model)
                }
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }

    func inviteProfile(countryCode: String, phoneNumber: String, completionHandler: @escaping ((String?) -> Void)) {
        let param = [ "countryCode": countryCode, "phoneNumber": phoneNumber] as [String: Any]
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        
        ApiManagerWithCodable<InviteProfilesResponseModel>.makeApiCall(APIUrl.UserApis.invite,
                                                                       params: param,
                                                                       headers: headers,
                                                                       method: .put) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
               
            } else if resultModel?.statusCode == 200 {
                if let data = resultModel?.data{
                    completionHandler(data)
                }
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func processForLikeProfileData(id: String, isLiked: Int) {
        var params = [String:Any]()
        params[WebConstants.profileId] = id
        params[WebConstants.isLiked] = isLiked
        
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
            }
        }
    }

}

// MARK: - UITextFieldDelegate
extension ShareViewModel: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if textField == txtField {
            searchAction(text: newString)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtField.endEditing(true)
        searchAction(text: txtField.text ?? "")
        return true
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.txtField.endEditing(true)
        searchAction(text: txtField.text ?? "")
    }
    
    func searchAction(text:String) {
        fliterPhonelists = text.isEmpty ? self.phonelists : self.phonelists.filter { $0.name?.range(of: text, options: .caseInsensitive) != nil }

        if text == "" { self.fliterPhonelists = self.phonelists }
        
        self.tableView?.reloadData()
    }
}

extension ShareViewModel:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fliterPhonelists.count
    }
//    private func imageWithInitials(initials: String) -> UIImage {
//           // Placeholder image creation logic
//           let renderer = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
//           let userImage = renderer.image { context in
//               UIColor.appBrownColor.setFill()
//               context.fill(CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
//
//               let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 20,weight: .semibold),
//                   .foregroundColor: UIColor.white
//               ]
//
//               let text = NSString(string: initials)
//               let textSize = text.size(withAttributes: attributes)
//               let origin = CGPoint(x: (50 - textSize.width) / 2, y: (50 - textSize.height) / 2)
//
//               text.draw(at: origin, withAttributes: attributes)
//           }
//
//           return userImage
//       }

    
//    func initials(firstName: String?, lastName: String?) -> String {
//        var initialsString = ""
//
//        if let firstInitial = firstName?.prefix(1) {
//            initialsString += String(firstInitial)
//        }
//
//        if let lastInitial = lastName?.prefix(1) {
//            initialsString += String(lastInitial)
//        }
//
//        return initialsString
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.shareCell, for: indexPath) as? shareTableViewCell {
            let imageDisplayName = self.fliterPhonelists[indexPath.row].name
            if let name = imageDisplayName, !name.isEmpty {
                cell.NameLabel.text = name
               // cell.userImage.setImage(string:name, color: UIColor.colorHash(name: name), circular: true, stroke: true)
               
             //   let nameStr = contactsVM.initials(firstName: firstName, lastName: lastName)
                let nameStr = contactsVM.getInitials(from: name, count: 2)
                if !nameStr.isEmpty{
                    let userImage = contactsVM.imageWithInitials(initials: nameStr)
                    cell.userImage.image = userImage
                }else{
                    cell.userImage.setImage(string:"-", color: UIColor.appBrownColor, circular: true, stroke: true)
                }
             //   cell.userImage.setImage(string:nameStr, color: UIColor.appBrownColor, circular: true, stroke: true)
                cell.userImage.contentMode = .scaleAspectFit
            } else {
               // cell.userImage.setImage(string:"-", color: UIColor.colorHash(name: "-"), circular: true, stroke: true)
                
                cell.userImage.setImage(string:"-", color: UIColor.appBrownColor, circular: true, stroke: true)
            }
            
            cell.sendButton.tag = indexPath.row
            if fliterPhonelists[indexPath.row].isPhoneVerified == 1 {
                //User exist on app
               // if sharedIds.contains(fliterPhonelists[indexPath.row].id ?? "") {
               // if shareIdValue.contains(indexPath.row) {
                if fliterPhonelists[indexPath.row].isSent == 1 {

                    cell.sendButton.backgroundColor = UIColor.appBrownColor
                    cell.sendButton.setTitleColor(UIColor.white, for: .normal)
                    cell.sendButton.setTitle("Sent ✓", for: .normal)

                } else {
                    if fliterPhonelists[indexPath.row].isBlocked == 1 {
                        cell.sendButton.backgroundColor = UIColor.white
                        cell.sendButton.setTitleColor(UIColor.appBrownColor, for: .normal)
                        //check for matchmaker and dating profile
                        let btnTitle = fliterPhonelists[indexPath.row].isHavingDatingProfile == 1 ? "Send" : "Share"
                        cell.sendButton.setTitle(btnTitle, for: .normal)
                        cell.sendButton.alpha = 0.5
                        cell.sendButton.isUserInteractionEnabled = false
                    } else {
                        cell.sendButton.backgroundColor = UIColor.white
                        cell.sendButton.setTitleColor(UIColor.black, for: .normal)
                        //check for matchmaker and dating profile
                        let btnTitle = fliterPhonelists[indexPath.row].isHavingDatingProfile == 1 ? "Send" : "Share"
                        cell.sendButton.setTitle(btnTitle, for: .normal)
                        cell.sendButton.alpha = 1
                        cell.sendButton.isUserInteractionEnabled = true
                    }
                }
            } else {
                //User not exist on app
                //if sharedIds.contains(fliterPhonelists[indexPath.row].id ?? "") {
                 //   if shareIdValue.contains(indexPath.row) {
                if fliterPhonelists[indexPath.row].isSent == 1 {

                    cell.sendButton.backgroundColor = UIColor.appBrownColor
                    cell.sendButton.setTitleColor(UIColor.white, for: .normal)
                    cell.sendButton.setTitle("Sent ✓", for: .normal)

                } else {
                    if fliterPhonelists[indexPath.row].isBlocked == 1 {
                        cell.sendButton.backgroundColor = UIColor.white
                        cell.sendButton.setTitleColor(UIColor.black, for: .normal)
                        cell.sendButton.setTitle("Share", for: .normal)
                        cell.sendButton.alpha = 0.5
                        cell.sendButton.isUserInteractionEnabled = false
                    } else {
                        cell.sendButton.backgroundColor = UIColor.white
                        cell.sendButton.setTitleColor(UIColor.black, for: .normal)
                        cell.sendButton.setTitle("Share", for: .normal)
                        cell.sendButton.alpha = 1
                        cell.sendButton.isUserInteractionEnabled = true
                    }
                }
            }
            
            cell.sendButton.addTarget(self, action: #selector(sendButtonAction(sender:)), for: .touchUpInside)

            cell.blockButton.setTitle("", for: .normal)
            cell.blockButton.borderColor = UIColor.clear
            
            // cell.blockButton.tag = indexPath.row
//            if fliterPhonelists[indexPath.row].isBlocked == 1 {
//                cell.blockButton.borderColor = UIColor.appSeparator
//                cell.blockButton.setTitleColor(UIColor.appSeparator, for: .normal)
//                cell.sendButton.borderColor = UIColor.appSeparator
//                cell.sendButton.setTitleColor(UIColor.appSeparator, for: .normal)
//            } else {
//                cell.blockButton.borderColor = UIColor.appBorder
//                cell.blockButton.setTitleColor(UIColor.appBorder, for: .normal)
//                cell.sendButton.borderColor = UIColor.appBorder
//                cell.sendButton.setTitleColor(UIColor.appBorder, for: .normal)
//                cell.blockButton.addTarget(self, action: #selector(blockButtonAction(sender:)), for: .touchUpInside)
//            }
        
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func blockButtonAction(sender: UIButton){
        let buttonTag = sender.tag
        let alert = UIAlertController(title: "Are you sure you want to block this user?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            var parms = [String : Any]()
            parms[WebConstants.phoneNumber] = self.fliterPhonelists[buttonTag].number
            parms[WebConstants.countryCode] = self.fliterPhonelists[buttonTag].countryCode
            parms[WebConstants.name] = self.fliterPhonelists[buttonTag].name
            self.processForBlockContactData(parms:parms)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    @objc func sendButtonAction(sender: UIButton) {
        let buttonTag = sender.tag
       // if (!self.sharedIds.contains(self.fliterPhonelists[buttonTag].id ?? "")) {
           // if !shareIdValue.contains(buttonTag) {
        if fliterPhonelists[buttonTag].isSent != 1 {

            if fliterPhonelists[buttonTag].isPhoneVerified == 1 {
                
                //User exist on app -> Like the profile then Send
                let model = fliterPhonelists[buttonTag]
                if model.isLiked == 0 {
                    //if not liked then like first
                    self.processForLikeProfileData(id: model.id ?? "", isLiked: 1)
                }
                
             //   self.sharedIds.append(self.fliterPhonelists[buttonTag].id ?? "")
                //self.shareIdValue.append(buttonTag)
                 fliterPhonelists[buttonTag].isSent = 1
                
                for (index, item) in self.phonelists.enumerated(){
                    if self.fliterPhonelists[buttonTag].number == item.number && self.fliterPhonelists[buttonTag].name == item.name{
                        self.phonelists[index].isSent = 1
                    }
                }

                let sendDataModel = FirebaseSendDataModel(id: model.id ?? "", dialogStatus: model.isYourProfileLiked == 1 ? 2 : 1, userName: "\(model.firstName ?? "") \(model.lastName ?? "")", userPic: model.dp, isSubscriptionPlanActive: model.isSubscriptionPlanActive, isConnection: model.isPhoneBook, countryCode: model.countryCode, phoneNumber: model.number, isPhoneVerified: model.isPhoneVerified)
                showLoader()
                FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel, completionHandler: { status, chatRoom in
                    hideLoader()
                    if status {
                        self.sendSharedProfile(chatRoom: chatRoom)
                        showMessage(with: "Profile shared successfully", theme: .success)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
                
            } else {
                //User not exist on app -> Share
                inviteProfile(countryCode: fliterPhonelists[buttonTag].countryCode ?? "", phoneNumber: fliterPhonelists[buttonTag].number ?? "") { userId in
               //     self.sharedIds.append(self.fliterPhonelists[buttonTag].id ?? "")
                  //  self.shareIdValue.append(buttonTag)
                    self.fliterPhonelists[buttonTag].isSent = 1
                    for (index, item) in self.phonelists.enumerated(){
                        if self.fliterPhonelists[buttonTag].number == item.number && self.fliterPhonelists[buttonTag].name == item.name{
                            self.phonelists[index].isSent = 1
                        }
                    }

                    let sendDataModel = FirebaseSendDataModel(id: userId, dialogStatus: 3, userName: self.fliterPhonelists[buttonTag].name ?? "", userPic: "dp", isSubscriptionPlanActive: 0, isConnection: 1, countryCode: self.fliterPhonelists[buttonTag].countryCode ?? "", phoneNumber: self.fliterPhonelists[buttonTag].number ?? "", isPhoneVerified: self.fliterPhonelists[buttonTag].isPhoneVerified)
                    showLoader()
                    FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel, completionHandler: { status, chatRoom in
                        hideLoader()
                        if status {
                            self.sendSharedProfile(chatRoom: chatRoom)
                            showMessage(with: "Profile shared successfully", theme: .success)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func sendSharedProfile(chatRoom: ChatRoomModel?) {
        let createDate = Int64(Date().timeIntervalSince1970 * 1000)
        let autoId = FirestoreManager.getMessageAutoId(chat_dialog_id: chatRoom?.chat_dialog_id ?? "")
        var receiver_id: [String: String] = [:]
        
        chatRoom?.user_id?.keys.forEach({ user_id in
            receiver_id[user_id] = user_id
        })
        
        var idsArr: [String] = []
        var imagesArr: [String] = []
        var shareNameArr : [String] = []
        for (index, _) in self.profiles.enumerated() {
            idsArr.append(self.profiles[index].id ?? "")
            shareNameArr.append(self.profiles[index].firstName ?? "")
            let images = self.profiles[index].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            if let images = images, !images.isEmpty {
                let image = images[0]
                imagesArr.append(image.file ?? "")
            }
        }
     //   let shareNameConcatenatedString = shareNameArr.joined(separator: ",")
        let idsConcatenatedString = idsArr.joined(separator: ",")
        let imagesConcatenatedString = imagesArr.joined(separator: ",")
        let message = MessageModel(message_id: autoId, message: idsConcatenatedString, message_type: 4, message_time: createDate, firebase_message_time: createDate, chat_dialog_id: chatRoom?.chat_dialog_id ?? "", sender_id: UserModel.shared.user.id, attachment_url: imagesConcatenatedString, receiver_id: receiver_id, reply_msg: "", reply_id: "", reply_type: 0, reply_msg_id: "")
                                
        FirestoreManager.sendMessageOnFirebase(message: message, chatRoom: chatRoom!)
        FirestoreManager.updateLastMessageAndUnReadCount(chatRoom: chatRoom, message: message)
    }
}
