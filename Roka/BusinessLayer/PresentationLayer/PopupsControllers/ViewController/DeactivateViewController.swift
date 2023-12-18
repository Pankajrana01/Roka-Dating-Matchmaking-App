//
//  DeleteViewController.swift
//  Roka
//
//  Created by ios on 12/10/23.
//

import UIKit

class DeactivateViewController: BaseAlertViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.deactivate
    }

    lazy var viewModel: DeactivateAccountViewModel = DeactivateAccountViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! LogoutViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    
    var callbacktopreviousscreen: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func deactivateButtonAction(_ sender: UIButton) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.viewModel.processForDeActivateProfile(isDeactivate: 1) { result in
                self.dismiss(animated: true) {
                    self.callbacktopreviousscreen?()
                }
            }
        } else {
            self.viewModel.processForDeActivateProfile(isDeactivate: viewModel.isDeactivate) { result in
                self.dismiss(animated: true) {
                    self.callbacktopreviousscreen?()
                }
            }
        }
        
    }

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
}
