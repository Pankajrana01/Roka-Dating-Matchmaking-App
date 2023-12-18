//
//  BlockedUsersViewController.swift
//  Roka
//
//  Created by  Developer on 24/10/22.
//

import UIKit

class BlockedUsersViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.blockedUsers
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.blockedUsers
    }

    lazy var viewModel: BlockedUsersViewModel = BlockedUsersViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! BlockedUsersViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataFoundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            addNavigationBackButton()
            self.topView.backgroundColor = UIColor.appTitleBlueColor
        } else {
            addNavigatioBlacknBackButton()
            self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
        }
        self.title = "Blocked Users"
       // showNavigationBackButton(title: "  Blocked Users")
        viewModel.tableView = tableView
        viewModel.noDataFoundView = noDataFoundView
        self.noDataFoundView.isHidden = true
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.rightNavButtonClicked))
//        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
//            rightButton.image = UIImage(named: "New_Contact_Book_Icon")
//        } else {
//            rightButton.image = UIImage(named: "im_contact_matching")
//        }
        // Here creating emptyButton just to give some space from the left side to rightButton.
      //  let emptyRightButton = UIBarButtonItem()
       // rightButton.title = ""
     //   rightButton.tintColor = UIColor.appTitleBlueColor
//        self.navigationItem.rightBarButtonItem = rightButton
        
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            btn2.setImage(UIImage(named: "New_Contact_Book_Icon"), for: .normal)
        } else {
            btn2.setImage(UIImage(named: "im_contact_matching"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(rightNavButtonClicked(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.rightBarButtonItem = barButton

        
        
        
        
        
        self.viewModel.processForGetBlockedUserContactsData { status in
            
        }
    }
    

    @objc func rightNavButtonClicked(_ sender: UIButton) {
        viewModel.proceedForContactsUsersScreen()
    }
}


