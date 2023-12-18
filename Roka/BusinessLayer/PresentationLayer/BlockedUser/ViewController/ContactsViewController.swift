//
//  ContactsViewController.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit
import Contacts

class ContactsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.blockedUsers
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.contactUsers
    }

    lazy var viewModel: ContactViewModel = ContactViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ContactsViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.addNavigationBackButton()
            self.topView.backgroundColor = UIColor.appTitleBlueColor
        } else {
            addNavigatioBlacknBackButton()
            self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
        }
//        showNavigationBackButton(title: "  Contacts")
        self.title = "Contacts"
        viewModel.tableView = tableview

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        askUserForContactsPermission() 
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addNavigatioBlacknBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
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
                    self.tableview.reloadData()
                }
            } else {
                print("Access denied..")
            }
        }
    }
  
}

