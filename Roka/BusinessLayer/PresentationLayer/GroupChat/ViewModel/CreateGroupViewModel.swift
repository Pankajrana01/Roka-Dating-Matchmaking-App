//
//  CreateGroupViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/12/22.
//

import Foundation
import UIKit
import Contacts
import TagListView

class CreateGroupUsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var selectButton: UIButton!
}

struct TextFieldModel {
    var nameTextFieldData: String?
    var searchTextFieldData: String?
    
    init(textData1: String, textData2: String) {
        nameTextFieldData  = textData1
        searchTextFieldData = textData2
    }
}

class CreateGroupViewModel: BaseViewModel {
    var isNeedToSendLastMessgaeId : Bool = false
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var phonelists:[UserPhoneBookModel] = []
    var fliterPhonelists:[UserPhoneBookModel] = []
    var contactsVM = ContactsViewModel()
    var dataModel = TextFieldModel(textData1: "", textData2: "")
    var selectionArr = [UserPhoneBookModel]()
    var profiles = [ProfilesModel]()
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    
    weak var createBtn: UIButton!
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: TableViewNibIdentifier.createGroupNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.createGroupCell)
    }
    
    // MARK: - API Call...
    func processForUpdateUserContactsData(_ result:@escaping(String?) -> Void) {
        var parms = [String : Any]()
        parms[WebConstants.numberList] = contactsVM.numberListDictionary
        DispatchQueue.main.async {
            showProgressLoader(text: "Loading contacts...")
        }
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]

        ApiManagerWithCodable<UserPhoneBookListModel>.makeApiCall(isComeFor == "oneToOne" ? APIUrl.UserApis.userPhoneBookListV2 : APIUrl.UserApis.userPhoneBookList,
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
                self.fliterPhonelists.append(contentsOf: self.phonelists)
                result("success")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func createGroupApi(_ result:@escaping(ChatRoomModel?) -> Void) {
        if dataModel.nameTextFieldData ?? "" == "" {
            showMessage(with: ValidationError.groupName)
        } else if selectionArr.count == 0 {
            showMessage(with: ValidationError.addMember)
            
        } else {
            let groupMembers = selectionArr.map({ value in
                return ["id": value.userId ?? "", "countryCode": value.countryCode ?? "", "number": value.number ?? "", "name": value.name]
            })
            
            guard var parms = ["groupName": dataModel.nameTextFieldData!, "groupMembers": groupMembers] as? [String : Any] else { return }
            if profiles.count > 0 {
                let profileIds = profiles.map({ $0.id })
                parms["profileIds"] = profileIds
            }
            
            showLoader()
            
            let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
            ApiManager.makeApiCall(APIUrl.UserApis.groups,
                                   params: parms,
                                   headers: headers,
                                   method: .post) { response, _ in
                if !self.hasErrorIn(response) {
                    if let responseData = response![APIConstants.data] as? [String: Any] {
                        let groupId = responseData["groupId"] as? String ?? ""
                        let groupName = responseData["groupName"] as? String ?? ""
                        let listing = responseData["listing"] as? [[String: Any]] ?? []
                        
                        let chatRoom = FirestoreManager.createGroupChatRoom(name: groupName, chatDialogId: groupId, groupMemberList: listing,isNeedToSendLastMessgaeId: self.isNeedToSendLastMessgaeId)
                        result(chatRoom)
                    }
                }
                hideLoader()
            }
        }
        

    }
    
    func oneToOneChatFeature(_ result: @escaping(ChatRoomModel?) -> Void) {
        if selectionArr.count == 0 {
            showMessage(with: ValidationError.addMember)
            
        } else {
            showLoader()
            if selectionArr.first?.isPhoneVerified == 1 {
                
                //User exist on app -> Like the profile then Send
                let model = selectionArr.first
                if model?.isLiked == 0 {
                    //if not liked then like first
                    self.processForLikeProfileData(id: self.selectionArr.first?.userId ?? "", isLiked: 1)
                }
                
                let sendDataModel = FirebaseSendDataModel(id: model?.id, dialogStatus: model?.isYourProfileLiked == 1 ? 2 : 1, userName: "\(model?.firstName ?? "") \(model?.lastName ?? "")", userPic: model?.dp, isSubscriptionPlanActive: model?.isSubscriptionPlanActive, isConnection: model?.isPhoneBook, countryCode: model?.countryCode, phoneNumber: model?.number, isPhoneVerified: model?.isPhoneVerified ?? 0)
                FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel, completionHandler: { status, chatRoom in
                    hideLoader()
                    if status {
                        DispatchQueue.main.async {
                            result(chatRoom)
                        }
                    }
                })
            } else {
                //User not exist on app -> Share
                inviteProfile(countryCode: selectionArr.first?.countryCode ?? "", phoneNumber: selectionArr.first?.number ?? "") { userId in
                    let sendDataModel = FirebaseSendDataModel(id: userId, dialogStatus: 3, userName: self.selectionArr.first?.name ?? "", userPic: "dp", isSubscriptionPlanActive: 0, isConnection: 1, countryCode: self.selectionArr.first?.countryCode ?? "", phoneNumber: self.selectionArr.first?.number ?? "", isPhoneVerified: self.selectionArr.first?.isPhoneVerified ?? 0)
                    FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel, completionHandler: { status, chatRoom in
                        hideLoader()
                        if status {
                            DispatchQueue.main.async {
                                result(chatRoom)
                            }
                        }
                    })
                }
            }
        }
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
        for (index, _) in self.profiles.enumerated() {
            idsArr.append(self.profiles[index].id ?? "")
            let images = self.profiles[index].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            if let images = images, !images.isEmpty {
                let image = images[0]
                imagesArr.append(image.file ?? "")
            }
        }
        
        let idsConcatenatedString = idsArr.joined(separator: ",")
        let imagesConcatenatedString = imagesArr.joined(separator: ",")
        let message = MessageModel(message_id: autoId, message: idsConcatenatedString, message_type: 4, message_time: createDate, firebase_message_time: createDate, chat_dialog_id: chatRoom?.chat_dialog_id ?? "", sender_id: UserModel.shared.user.id, attachment_url: imagesConcatenatedString, receiver_id: receiver_id, reply_msg: "", reply_id: "", reply_type: 0, reply_msg_id: "")
        
        FirestoreManager.sendMessageOnFirebase(message: message, chatRoom: chatRoom!)
        FirestoreManager.updateLastMessageAndUnReadCount(chatRoom: chatRoom, message: message)
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
extension CreateGroupViewModel: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = NSIndexPath(row: textField.tag, section: 0)
        if let cell = tableView.cellForRow(at: index as IndexPath) as? CreateGroupTableViewCell {
            if textField == cell.groupNameTextField {
                dataModel.nameTextFieldData = textField.text
            } else if textField == cell.searchTextField {
                dataModel.searchTextFieldData = textField.text
                searchAction(text: textField.text ?? "")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hostViewController.view.endEditing(true)
        searchAction(text: textField.text ?? "")
        return true
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.hostViewController.view.endEditing(true)
        //searchAction(text: textField.text ?? "")
    }
    
    func searchAction(text:String) {
        fliterPhonelists = text.isEmpty ? self.phonelists : self.phonelists.filter{ $0.name?.range(of: text, options: .caseInsensitive) != nil }
        
        if text == "" { self.fliterPhonelists = self.phonelists }
        
        self.tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
}

extension CreateGroupViewModel:  UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return self.fliterPhonelists.count //contactsVM.filteredContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.createGroupCell, for: indexPath) as? CreateGroupTableViewCell{
                cell.groupNameTextField.delegate = self
                //cell.searchTextField.delegate = self
                cell.searchTextField.tag = indexPath.row
                cell.groupNameTextField.tag = indexPath.row
                
                cell.groupNameTextField.text = dataModel.nameTextFieldData
                cell.searchTextField.text = dataModel.searchTextFieldData
                
                cell.groupNameHeightConstant.constant = isComeFor == "oneToOne" ? 0 : 95
                
                cell.callBackForSearchTextField = { selectedIndex, newString in
                    print(selectedIndex, newString)
                    self.dataModel.searchTextFieldData = newString
                    //cell.searchTextField.text = newString
                    self.searchAction(text: newString)
                }
                cell.searchTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
                if isComeFor == "oneToOne" {
                    if selectionArr.count > 0{
                        self.createBtn.isHidden = false
                        cell.searchHeightConst.constant = 0
                        cell.suggestTopConstant.constant = 13
                        cell.searchTextField.isHidden = true
                    }else{
                        self.createBtn.isHidden = true
                        cell.searchHeightConst.constant = 13
                        cell.suggestTopConstant.constant = 30
                        cell.searchTextField.isHidden = false
                    }
                }
                cell.tagListView.delegate = self
                cell.tagListView.removeAllTags()
                cell.tagListView.textFont = UIFont(name: "SFProDisplay-Regular", size: 15.0)!
                let selectedUsersName = selectionArr.map({$0.name ?? ""})
                cell.tagListView.addTags(selectedUsersName)
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.createGroupUsersCell, for: indexPath) as? CreateGroupUsersTableViewCell{
                
                let imageDisplayName = self.fliterPhonelists[indexPath.row].name
                
                if let name = imageDisplayName, !name.isEmpty {
                    cell.userName.text = name
                    let nameStr = contactsVM.getInitials(from: name, count: 2)
                    let userImage = contactsVM.imageWithInitials(initials: nameStr)
                    cell.userImage.image = userImage
                //    cell.userImage.setImage(string:name, color: UIColor.colorHash(name: name), circular: true, stroke: true)
                    cell.userImage.contentMode = .scaleAspectFit
                }else{
                    cell.userImage.setImage(string:"-", color: UIColor.colorHash(name: "-"), circular: true, stroke: true)
                }
                cell.selectButton.tag = indexPath.row
                cell.selectButton.addTarget(self, action: #selector(selectButtonDidPress(_:)),
                                            for: .touchUpInside)
                
                if selectionArr.contains(where: { $0.name == imageDisplayName }) {
                    cell.selectButton.setImage(UIImage(named: "Ic_selected_tick"), for: .normal)
                } else {
                    cell.selectButton.setImage(UIImage(named: "UnSelectRectangle"), for: .normal)
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func selectButtonDidPress(_ button: UIButton) {
        let imageDisplayName = self.fliterPhonelists[button.tag].name
        if let name = imageDisplayName, !name.isEmpty {
            if isComeFor == "oneToOne" {
                selectionArr.removeAll()
                selectionArr.append(self.fliterPhonelists[button.tag])
                
            } else {
                let index = self.selectionArr.firstIndex{ $0.name == name }
                if index == nil {
                    selectionArr.append(self.fliterPhonelists[button.tag])
                } else {
                    self.selectionArr.remove(at: index!)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
}

extension CreateGroupViewModel: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
        if isComeFor == "oneToOne" {
            selectionArr.removeAll()
            self.tableView.reloadData()
        } else {
            if let index = self.selectionArr.firstIndex(where: { $0.name == title }) {
                self.selectionArr.remove(at: index)
                self.tableView.reloadData()
            }
        }
    }
}
