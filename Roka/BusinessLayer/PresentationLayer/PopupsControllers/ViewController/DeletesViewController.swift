//
//  DeleteViewController.swift
//  Roka
//
//  Created by ios on 12/10/23.
//

import UIKit

class DeletesViewController: BaseAlertViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.delete
    }

    lazy var viewModel: DeleteAccountViewModel = DeleteAccountViewModel(hostViewController: self)
    
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

    
    @IBOutlet weak var confirmTextField: UITextField!
    var callbacktopreviousscreen: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.confirmTextField = confirmTextField
    }
    
    @IBAction func deactivateButtonAction(_ sender: UIButton) {
        viewModel.processForDeleteUserData { result in
            self.dismiss(animated: true) {
                self.callbacktopreviousscreen?()
            }
        }
        
    }

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
}
