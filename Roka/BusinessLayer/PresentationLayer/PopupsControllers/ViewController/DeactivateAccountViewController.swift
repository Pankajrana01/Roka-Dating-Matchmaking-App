//
//  DeactivateAccountViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 04/04/23.
//

import UIKit

class DeactivateAccountViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.deactivateAccount
    }

    lazy var viewModel: DeactivateAccountViewModel = DeactivateAccountViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isComeFrom : String,
                    isDeactivate :Int,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! DeactivateAccountViewController
        controller.show(over: host, isComeFrom: isComeFrom, isDeactivate: isDeactivate, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isComeFrom : String,
              isDeactivate: Int,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isComeFor = isComeFrom
        viewModel.isDeactivate = isDeactivate
        show(over: host)
    }

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.isComeFor == "MatchMakingProfile" {
            titleLbl.text = "Activate Account"
            subTitleLbl.text = "Are you sure you want to activate your account?"
        } else {
            titleLbl.text = "Deactivate Account"
            subTitleLbl.text = "Are you sure you want to deactivate your account?"
        }
    }
    
    @IBAction func yesButtonAction(_ sender: Any) {
        if viewModel.isComeFor == "DatingProfile" {
            self.viewModel.processForDeActivateProfile(isDeactivate: viewModel.isDeactivate) { result in
                self.dismiss(msg: "ChangeToMatchMaking")
            }
        } else {
            self.viewModel.processForDeActivateProfile(isDeactivate: viewModel.isDeactivate) { result in
                self.dismiss(msg: "refreshMatchMaking")
            }
        }
    }
    
    @IBAction func nobuttonAction(_ sender: Any) {
        self.dismiss()
    }
}
