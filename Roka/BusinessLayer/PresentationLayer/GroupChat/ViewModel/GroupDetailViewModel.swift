//
//  GroupDetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase

class GroupDetailViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var chatRoom: ChatRoomModel?
    var members: [MemberModel] = []
    var newAdminmembers: [MemberModel] = []
    var menuArray = ["Exit Group", "Leave and Delete Group"]
    weak var tableView: UITableView! { didSet { configureTableView() } }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.groupMembersNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.groupMembersCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.groupMembersFooterNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.groupMembersFooterCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.groupMembersHeaderNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.groupMembersHeaderCell)
  
    }
    
    func setupMembers() {
        members.removeAll()
        for (key, value) in chatRoom?.user_name ?? [:] {
            let img = chatRoom?.user_pic?[key] ?? "dp"
            let name = UserModel.shared.user.id == chatRoom?.dialog_admin ? value : chatRoom?.user_number?[key] ?? ""
            members.append(MemberModel.init(memberId: key, name: name, img: img))
        }
        members = members.sorted(by: { $0.name < $1.name })
    }
        
    func proceedForAddGroupMembers() {
        AddGroupMemberViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "", chatRoom: self.chatRoom) { success in
            self.fetchChatRoomDetails { }
        }
    }
    func proceedForEditGroupDetail() {
        EditGroupDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "", chatRoom: self.chatRoom!) { success in
            self.fetchChatRoomDetails {
            }
        }
    }
    
    func fetchChatRoomDetails(_ result:@escaping() -> Void) {
        let ref = Database.database().reference().child("Chats").child(self.chatRoom?.chat_dialog_id ?? "")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                do {
                    let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                    self.chatRoom = model
                    self.setupMembers()
                    self.tableView.reloadData()
                    result()
                } catch let error {
                    print(error)
                }

            }else{
                print("SnapDict is null")
            }
        })
    }
    
    func exitButtonActionClick(){
        //Admin ...
         if UserModel.shared.user.id == self.chatRoom?.dialog_admin {
                 self.newAdminmembers.removeAll()
                 for member in self.members {
                     if member.img != "dp" && member.img != "" && member.memberId != UserModel.shared.user.id {
                         self.newAdminmembers.append(member)
                     }
                 }
                 if self.newAdminmembers.count != 0 {
                     let newAdmin = self.newAdminmembers.randomElement()
                     // Make new Admin ...
                     FirestoreManager.updateNewAdminStatusOnFirebase(chatRoom: self.chatRoom, newAdmin: newAdmin?.memberId ?? "")
                     
                 } else {
                     self.newAdminmembers.removeAll()
                     for member in self.members where member.memberId != UserModel.shared.user.id {
                         //if member.memberId != UserModel.shared.user.id {
                             self.newAdminmembers.append(member)
                         //}
                     }
                     if self.newAdminmembers.count > 0{
                         let newAdmin = self.newAdminmembers[0]
                         // Make new Admin ...
                         FirestoreManager.updateNewAdminStatusOnFirebase(chatRoom: self.chatRoom, newAdmin: newAdmin.memberId ?? "")
                     }
                 }
                 //Exit This Group
                 FirestoreManager.leaveGroup(group: self.chatRoom, userId: UserModel.shared.user.id)
                 self.hostViewController.navigationController?.popViewController(animated: true)

         }
    }
    
    func leaveAndDeleteActionClicked(){
        
        if UserModel.shared.user.id == self.chatRoom?.dialog_admin {
            //Delete This Group
            FirestoreManager.deleteChatOnFirebase(chatRoom: self.chatRoom!)
            self.hostViewController.navigationController?.popViewController(animated: true)
            // Resolved
        }else{
            // Member ....
          //  Exit this group
            FirestoreManager.leaveGroup(group: self.chatRoom, userId: UserModel.shared.user.id)
            self.hostViewController.navigationController?.popViewController(animated: true)
            
        }
    }
}

extension GroupDetailViewModel:  UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
       // return 3

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
//        else if section == 2 {
//            return UserModel.shared.user.id == chatRoom?.dialog_admin ? 2 : 1
//        }
        else {
            return members.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.groupMembersHeaderCell, for: indexPath) as? GroupDetailHeaderViewCell{
                cell.groupName.text = chatRoom?.name
                
                let pic = chatRoom?.pic ?? "dp"
                if pic != "dp" {
                    cell.groupImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "ic_group"), completed: nil)
                } else {
                    cell.groupImage.image = #imageLiteral(resourceName: "ic_group")
                }
                                
                if UserModel.shared.user.id == chatRoom?.dialog_admin { //Admin
                    cell.addMemberButton.isHidden = false
                } else {
                    cell.addMemberButton.isHidden = true
                }
                if members.count > 0{
                    cell.totalMemberCountLbl.text = "\(members.count) Members"
                }
                
                cell.callBackForSelectAddMemberButton = { selectedIndex in
                    print(selectedIndex)
                    self.proceedForAddGroupMembers()
                }
                
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.groupMembersCell, for: indexPath) as? GroupMembersTableViewCell {
                let adminTxt = members[indexPath.row].memberId == chatRoom?.dialog_admin ? " (Admin)" : ""
                cell.name.text = members[indexPath.row].name + adminTxt
                
                let img = members[indexPath.row].img
                img == "dp" ? cell.imgView.image =  UIImage(named: "Avatar") : cell.imgView.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + img), placeholderImage: UIImage(named: "Avatar"), completed:nil)
               
                if UserModel.shared.user.id == chatRoom?.dialog_admin { //Admin
                    cell.removeButton.isHidden = members[indexPath.row].memberId == chatRoom?.dialog_admin
                } else {
                    cell.removeButton.isHidden = true
                }
                cell.removeButton.tag = indexPath.row
                cell.callBackForRemoveButton = { index in
                    self.leaveGroupConfirmation(index: index)
                }
                return cell
            }
        }
//        else {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.groupMembersFooterCell, for: indexPath) as? GroupDetailFooterViewCell {
//                if members.count > 0 {
//
//                    cell.innerView.borderWidth = 1
//                    cell.innerView.cornerRadius = 20
//
//                    if indexPath.row == 0{
//                        cell.deleteButton.textColor = .black
//                        cell.innerView.borderColor = .black
//                    }else if indexPath.row == 1{
//                        cell.deleteButton.textColor = UIColor.appLightBorderColor
//                        cell.innerView.borderColor = UIColor.appLightBorderColor
//                    }
//
//                    if UserModel.shared.user.id == chatRoom?.dialog_admin {
//                        cell.deleteButton.text = self.menuArray[indexPath.row]
//                    } else {
//                        cell.deleteButton.text = UserModel.shared.user.id == chatRoom?.dialog_admin ? "Leave and Delete Group" : "Exit Group"
//                    }
//
//                    cell.callBackForDeleteButtonAction = {
//                       //Admin ...
//                        if UserModel.shared.user.id == self.chatRoom?.dialog_admin {
//                            if indexPath.row == 0 {
//                                self.newAdminmembers.removeAll()
//                                for member in self.members {
//                                    if member.img != "dp" && member.img != "" && member.memberId != UserModel.shared.user.id {
//                                        self.newAdminmembers.append(member)
//                                    }
//                                }
//                                if self.newAdminmembers.count != 0 {
//                                    let newAdmin = self.newAdminmembers.randomElement()
//                                    // Make new Admin ...
//                                    FirestoreManager.updateNewAdminStatusOnFirebase(chatRoom: self.chatRoom, newAdmin: newAdmin?.memberId ?? "")
//
//                                } else {
//                                    self.newAdminmembers.removeAll()
//                                    for member in self.members where member.memberId != UserModel.shared.user.id {
//                                        //if member.memberId != UserModel.shared.user.id {
//                                            self.newAdminmembers.append(member)
//                                        //}
//                                    }
//                                    let newAdmin = self.newAdminmembers[0]
//                                    // Make new Admin ...
//                                    FirestoreManager.updateNewAdminStatusOnFirebase(chatRoom: self.chatRoom, newAdmin: newAdmin.memberId ?? "")
//                                }
//                                //Exit This Group
//                                FirestoreManager.leaveGroup(group: self.chatRoom, userId: UserModel.shared.user.id)
//                                self.hostViewController.navigationController?.popViewController(animated: true)
//
//                            } else {
//                                //Delete This Group
//                                FirestoreManager.deleteChatOnFirebase(chatRoom: self.chatRoom!)
//                                self.hostViewController.navigationController?.popViewController(animated: true)
//                            }
//                        } else {
//                        // Member ....
//                            //Exit this group
//                            FirestoreManager.leaveGroup(group: self.chatRoom, userId: UserModel.shared.user.id)
//                            self.hostViewController.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                } else {
//                    cell.innerView.borderWidth = 1
//                    cell.innerView.cornerRadius = 20
//                    cell.deleteButton.textColor = .green
//                    cell.innerView.borderColor = .lightGray
//
//
//                    cell.deleteButton.text = "Leave and Delete Group"
//                }
//                return cell
//            }
//        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
//        else if indexPath.section == 2 {
//            return 60
//        }
        else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Return the desired space (height) between cells and footer
//        if section == 2 {
//            return 20.0
//        }
//        else{
            return 10.0
       // }
         // Adjust the value as needed
    }
    
    func leaveGroupConfirmation(index: Int) {
        let alert = UIAlertController(title: "Are you sure you want to remove \(self.members[index].name ) from this group?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            //Remove Action
            FirestoreManager.leaveGroup(group: self.chatRoom, userId: self.members[index].memberId!)
            self.fetchChatRoomDetails { }
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
}

struct MemberModel {
    let memberId: String?
    let name: String
    let img: String
}
