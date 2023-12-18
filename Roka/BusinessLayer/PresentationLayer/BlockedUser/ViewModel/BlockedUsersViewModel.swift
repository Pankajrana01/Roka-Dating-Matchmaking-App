//
//  BlockedUsersViewModel.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import Foundation
import UIKit

class BlockedUsersViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var blockedUsers:[BlockedUsers] = []
    weak var noDataFoundView: UIView!
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: BlockedUsersTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BlockedUsersTableViewCell.identifier)
    }

    func proceedForContactsUsersScreen() {
        ContactsViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    
    // MARK: - API Call...
    func processForGetBlockedUserContactsData(_ result:@escaping(String?) -> Void) {
        let param = [ "limit": 1000, "skip": "0"] as [String: Any]
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.blockUser,
                               params: param,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let responseData = response![APIConstants.data] as? [String: Any]{
                                        self.blockedUsers.removeAll()
                                        
                                        if let rows = responseData["rows"] as? [[String: Any]]{
                                            if rows.count != 0{
                                                self.noDataFoundView.isHidden = true
                                                self.tableView.isHidden = false
                                            } else {
                                                self.noDataFoundView.isHidden = false
                                                self.tableView.isHidden = true
                                            }
                                            for i in 0..<rows.count{
                                                if let row = rows[i] as? [String:Any] {
                                                    if let blockedUsersArr = row["blockedUser"] as? [String:Any] {
                                                        
                                                        let userImagesArr = blockedUsersArr["userImages"] as? [[String: Any]]
                                                        var userImgStr = ""
                                                        if let userImgDict = userImagesArr?.first as? [String: Any], let userImg = userImgDict["file"] as? String {
                                                            userImgStr = userImg
                                                        }
                                                        
                                                        self.blockedUsers.append(BlockedUsers(
                                                            id: blockedUsersArr["id"] as? String ?? "",
                                                            name: blockedUsersArr["firstName"] as? String ?? "",
                                                            countryCode: blockedUsersArr["countryCode"] as? String ?? "",
                                                            number: blockedUsersArr["phoneNumber"] as? String ?? "",
                                                            lastName: blockedUsersArr["lastName"] as? String ?? "",
                                                            userImage: userImgStr
                                                        ))
                                                    }
                                                }
                                            }
                                        } else {
                                            self.noDataFoundView.isHidden = false
                                            self.tableView.isHidden = true
                                        }
                                        result("success")
                                        self.tableView.reloadData()
                                    }
                                    
                                    
                                }
            hideLoader()
        }
    }
   
    // MARK: - API Call...
    func processForUnBlockContactData(parms:[String:Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.unblockContacts,
                               params: parms,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let _ = response![APIConstants.data] as? [String: Any]{
                                        showSuccessMessage(with: StringConstants.unblockUsersSuccess)
                                        self.processForGetBlockedUserContactsData { results in }
                                    }
                                }
                hideLoader()
        }
    }
}


extension BlockedUsersViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlockedUsersTableViewCell.identifier) as! BlockedUsersTableViewCell
        
        let imageDisplayName = self.blockedUsers[indexPath.row].name
        
        if let name = imageDisplayName, !name.isEmpty {
            cell.labelProfileName.text = "\(name) \(self.blockedUsers[indexPath.row].lastName ?? "")"
            
            if let userImg = self.blockedUsers[indexPath.row].userImage{
                
                if userImg != "" {
                    let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImg
                    
                    cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                    
                } else {
                    cell.profileImage.setImage(string:name, color: UIColor.colorHash(name: name), circular: true, stroke: true)
                }
            }else{
                cell.profileImage.setImage(string:name, color: UIColor.colorHash(name: name), circular: true, stroke: true)
            }
            cell.profileImage.contentMode = .scaleAspectFill
        }else{
            
            cell.labelProfileName.text = "\(self.blockedUsers[indexPath.row].countryCode ?? "") " + "\(self.blockedUsers[indexPath.row].number ?? "")"
            
            //cell.profileImage.setImage(string:"-", color: UIColor.colorHash(name: "-"), circular: true, stroke: true)
        }
        
        
        cell.buttonUnblock.setTitle("Unblock", for: .normal)
        cell.buttonUnblock.tag = indexPath.row
        cell.buttonUnblock.addTarget(self, action: #selector(unblockButtonAction(sender:)), for: .touchUpInside)
        return cell
        
    }
    @objc func unblockButtonAction(sender: UIButton){
        let buttonTag = sender.tag
        let alert = UIAlertController(title: "Are you sure you want to unblock this user?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            var parms = [String : Any]()
            parms[WebConstants.phoneNumber] = self.blockedUsers[buttonTag].number
            parms[WebConstants.countryCode] = self.blockedUsers[buttonTag].countryCode
            self.processForUnBlockContactData(parms:parms)
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
