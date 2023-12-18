//
//  PendingVerificationViewController.swift
//  Roka
//
//  Created by  Developer on 03/01/23.
//

import UIKit

class PendingVerificationViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.pendingVerification
    }

    lazy var viewModel: PendingVerificationViewModel = PendingVerificationViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! PendingVerificationViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - IBActions
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.dismiss()
    }
}
