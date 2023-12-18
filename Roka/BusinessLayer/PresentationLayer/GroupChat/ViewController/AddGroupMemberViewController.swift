//
//  AddGroupMemberViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit
import Contacts

class AddGroupMemberViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.groupChat
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.addGroupMember
    }

    lazy var viewModel: AddGroupMemberViewModel = AddGroupMemberViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    chatRoom: ChatRoomModel?,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! AddGroupMemberViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.chatRoom = chatRoom
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var topStaticLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      //  showNavigationBackButton(title: "   Add friend’s to group")
        self.navigationController?.isNavigationBarHidden = false
        viewModel.tableView = tableView
        viewModel.txtField = txtField
        
        addNavigationBackButton()
        self.title = "Add friends to group"


        askUserForContactsPermission()
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.topStaticLabel.backgroundColor = UIColor.loginBlueColor
        }else{
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
            self.topStaticLabel.backgroundColor = UIColor.appTitleBlueColor
        }
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func askUserForContactsPermission() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted: Bool, err: Error?) in
            if let err = err {
                print("Failed to request access with error \(err)")
                return
            }
            if granted {
                print("User has granted permission for contacts")

                self.viewModel.contactsVM.fetchContacts { status in
                    if status == "success"{
                        self.viewModel.contactsVM.updateContacts { status in
                            if status == "success"{
                                self.viewModel.processForUpdateUserContactsData { results in }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Access denied..")
            }
        }
    }

    @IBAction func addSelectedButtonAction(_ sender: UIButton) {
        viewModel.addSelectedMembersToGroup()
    }
}
