//
//  CreateGroupViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/12/22.
//

import UIKit
import Contacts
class CreateGroupViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.groupChat
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.createGroup
    }

    lazy var viewModel: CreateGroupViewModel = CreateGroupViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    profiles: [ProfilesModel],
                    isNeedToSendLastMessgaeId: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! CreateGroupViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.profiles = profiles
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel.isNeedToSendLastMessgaeId = isNeedToSendLastMessgaeId
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //showNavigationBackButton(title: "   New message")
        addNavigationBackButton()
        if viewModel.isComeFor == "group" {
            self.title = "New Group"
            self.createButton.setTitle("Start group chat", for: .normal)
        } else {
            self.title = "New message"
            createButton.setTitle(viewModel.isComeFor == "oneToOne" ? "Start Chat" : "Start Group Chat" , for: .normal)
        }
        self.navigationController?.isNavigationBarHidden = false
        viewModel.tableView = tableView
        viewModel.createBtn = createButton
        askUserForContactsPermission()
        
        // Do any additional setup after loading the view.
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.topLabel.backgroundColor = UIColor.loginBlueColor
        }else{
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
            self.topLabel.backgroundColor = UIColor.appTitleBlueColor
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

    @IBAction func createButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if viewModel.isComeFor == "oneToOne" { // One to One
            viewModel.oneToOneChatFeature({ chatRoom in
                self.moveToChatRoomScreen(chatRoom: chatRoom)
            })
        } else { //Create Group
            viewModel.createGroupApi { chatRoom in
                if self.viewModel.profiles.count > 0 {
                    self.viewModel.sendSharedProfile(chatRoom: chatRoom)
                }
                self.moveToChatRoomScreen(chatRoom: chatRoom)
            }
        }
    }
    
    func moveToChatRoomScreen(chatRoom: ChatRoomModel?) {
        var vcs = self.navigationController!.viewControllers // get all vcs
        vcs = vcs.dropLast() // remove last vc
        
        let controller = ChatViewController.getController(with: "", chatRoom: chatRoom!) as! ChatViewController
        vcs.append(controller) // append it

        self.navigationController!.setViewControllers(vcs,animated:true)
    }
}

