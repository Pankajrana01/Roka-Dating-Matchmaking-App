//
//  AccountDetailsViewController.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class AccountDetailsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.accountDetails
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.accountDetails
    }

    lazy var viewModel: AccountDetailViewModel = AccountDetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! AccountDetailsViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        addNavigationBackButton()
        self.title = "Account Details"
        //showNavigationBackButton(title: "Account Details")
        self.viewModel.tableView = tableView

    }
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        showLoader()
        viewModel.processForGetUserData { result in
            self.viewModel.processForGetUserProfileData { result in
                hideLoader()
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Action for Edit Profile Button...
    @IBAction func editProfilePressed(_ sender: UIButton) {
        viewModel.proceedForBasicInfoScreen()
    }
    
}

