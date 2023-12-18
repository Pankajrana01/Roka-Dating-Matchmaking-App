//
//  SelectionModeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 19/07/23.
//

import UIKit

class SelectionModeViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.selectUserProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.selctionMode
    }

    lazy var viewModel: SelectionModeViewModel = SelectionModeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SelectionModeViewController
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func matchForYouButtonAction(_ sender: UIButton) {
        GlobalVariables.shared.selectedProfileMode = "Dating"
        viewModel.proceedForOnBoardingScreen(isComeFor: "")
    }
    
    @IBAction func MatchForOthersButtonAction(_ sender: UIButton) {
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        viewModel.proceedForOnBoardingScreen(isComeFor: "MatchMaking")
    }
    
}
