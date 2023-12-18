//
//  AddGroupMemberViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import Foundation
import UIKit
import Contacts

class AddGroupMemberViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var chatRoom: ChatRoomModel?

    var phonelists:[UserPhoneBookModel] = []
    var fliterPhonelists:[UserPhoneBookModel] = []
    var contactsVM = ContactsViewModel()
    var selectionArr = [UserPhoneBookModel]()

    weak var tableView: UITableView! { didSet { configureTableView() } }
    weak var txtField: UITextField! { didSet { configureTextField() } }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.createGroupNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.createGroupCell)
    }
    
    private func configureTextField() {
        txtField.delegate = self
        txtField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    // MARK: - API Call...
    func processForUpdateUserContactsData(_ result:@escaping(String?) -> Void) {
        var parms = [String : Any]()
        parms[WebConstants.numberList] = contactsVM.numberListDictionary
        DispatchQueue.main.async {
            showProgressLoader(text: "Loading contacts...")
        }
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<UserPhoneBookListModel>.makeApiCall(APIUrl.UserApis.userPhoneBookList,
                                                                  params: parms,
                                                                  headers: headers,
                                                                  method: .post) { (response, resultModel) in
            hideLoader()
            if !self.hasErrorIn(response) {
                self.phonelists.removeAll()
                
                //Exclude all those which are already added
                let allResult = resultModel?.data ?? []
                let newContactArray = allResult.reduce(into: [UserPhoneBookModel]()) { result, model in
                    if !result.contains(where: { $0.number == model.number }) {
                        result.append(model)
                    }
                }
                let user_id = self.chatRoom?.user_id as? [String: String] ?? [:]
                let allKeys: [String] = user_id.map({ $0.key })
                
                for item in newContactArray {
                    if !allKeys.contains(item.userId ?? "") {
                        self.phonelists.append(item)
                    }
                }
                
                self.fliterPhonelists.append(contentsOf: self.phonelists)
                result("success")
                self.tableView.reloadData()
            }
        }
    }
    
    func addSelectedMembersToGroup()  {
        for value in selectionArr {
            FirestoreManager.addMemberToGroup(group: chatRoom, dict: value)
        }
        completionHandler?(true)
        self.hostViewController.navigationController?.popViewController(animated: true)
    }
}

extension AddGroupMemberViewModel:  UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.fliterPhonelists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                cell.selectButton.setImage(UIImage(named: "Ic_unselected_tick"), for: .normal)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func selectButtonDidPress(_ button: UIButton) {
        let imageDisplayName = self.fliterPhonelists[button.tag].name
        if let name = imageDisplayName, !name.isEmpty {
            let index = self.selectionArr.firstIndex{ $0.name == name }
            if index == nil {
                selectionArr.append(self.fliterPhonelists[button.tag])
            } else {
                self.selectionArr.remove(at: index!)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension AddGroupMemberViewModel: UITextFieldDelegate {
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
