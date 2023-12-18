//
//  SelectUserProfileViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class SelectUserProfileViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.selectUserProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.selectUserProfile
    }

    lazy var viewModel: SelectUserProfileViewModel = SelectUserProfileViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SelectUserProfileViewController
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationLogo()
        self.navigationController?.isNavigationBarHidden = false
        KAPPDELEGATE.initializeDatingNavigationBar()
        viewModel.tableView = tableView
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.count = 0
    }


}
