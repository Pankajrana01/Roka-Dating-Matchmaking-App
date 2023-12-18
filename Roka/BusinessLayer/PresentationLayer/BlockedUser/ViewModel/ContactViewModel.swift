//
//  ContactViewModel.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import Foundation
import Contacts
import UIKit

class ContactViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var contactsVM = ContactsViewModel()
    var phonelists:[UserPhoneBookModel] = []
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: BlockedUsersTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BlockedUsersTableViewCell.identifier)
    }
    
    
    // MARK: - API Call...
    func processForUpdateUserContactsData(_ result:@escaping(String?) -> Void) {
        var parms = [String : Any]()
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
                
                //Exclude all those which are already added
                let allResult = resultModel?.data ?? []
                let newArray = allResult.reduce(into: [UserPhoneBookModel]()) { result, model in
                    if !result.contains(where: { $0.number == model.number }) {
                        result.append(model)
                    }
                }

                for item in newArray {
                    if item.isPhoneVerified == 0 && item.isBlocked == 0 {
                        self.phonelists.append(item)
                    }
                }
                
                result("success")
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
}


extension ContactViewModel: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return contactsVM.getNumberOfSectionsForContacts()
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phonelists.count //contactsVM.getNumberOfContacts(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BlockedUsersTableViewCell.identifier) as? BlockedUsersTableViewCell{
            
//            cell.labelProfileName.text = contactsVM.getContactName(forIndexPath: indexPath)
//            cell.buttonUnblock.setTitle("Block", for: .normal)
//
//            if let imageData = contactsVM.getProfilePhoto(forIndexPath: indexPath) {
//                cell.profileImage.image = UIImage(data: imageData)
//            } else {
//                cell.profileImage.image = #imageLiteral(resourceName: "Avatar")
//            }
            
            let imageDisplayName = self.phonelists[indexPath.row].name
            
            if let name = imageDisplayName, !name.isEmpty {
                cell.labelProfileName.text = name
                let nameStr = contactsVM.getInitials(from: name, count: 2)
                let userImage = contactsVM.imageWithInitials(initials: nameStr)
                cell.profileImage.image = userImage
              //  cell.profileImage.setImage(string:name, color: UIColor.colorHash(name: name), circular: true, stroke: true)
                cell.profileImage.contentMode = .scaleAspectFit
            }else{
                cell.profileImage.setImage(string:"-", color: UIColor.colorHash(name: "-"), circular: true, stroke: true)
            }
            
            cell.buttonUnblock.setTitle("Block", for: .normal)
            cell.buttonUnblock.tag = indexPath.row
            cell.buttonUnblock.addTarget(self, action: #selector(blockButtonAction(sender:)), for: .touchUpInside)

            return cell
        }
        return UITableViewCell()
    }
    
    @objc func blockButtonAction(sender: UIButton){
        let buttonTag = sender.tag
        let alert = UIAlertController(title: "Are you sure you want to block this user?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            var parms = [String : Any]()
            parms[WebConstants.phoneNumber] = self.phonelists[buttonTag].number
            parms[WebConstants.countryCode] = self.phonelists[buttonTag].countryCode
            parms[WebConstants.name] = self.phonelists[buttonTag].name
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
