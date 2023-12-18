//
//  RecoverViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import UIKit

class RecoverViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.recover
    }

    lazy var viewModel: RecoverViewModel = RecoverViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override class func show(from viewController: UIViewController,
                             forcePresent: Bool = true) {
        self.getController().show(from: viewController,
                                  forcePresent: forcePresent)
    }
    
    override func show(from viewController: UIViewController,
                       forcePresent: Bool = true) {
        self.modalPresentationStyle = .fullScreen
        if forcePresent {
            viewController.present(self, animated: false, completion: nil)
        } else { viewController.show(self, sender: nil) }
    }
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var sendButtonBottomConstraints: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        showNavigationBackButton(title: StringConstants.recoverTitle)
        viewModel.emailTextField = emailTextField
        viewModel.sendButton = sendButton
        viewModel.sendButtonBottomConstraints = sendButtonBottomConstraints
        viewModel.initializeKeyboardNotification()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func infoButtonAction(_ sender: Any) {
        viewModel.recoveryEmailInfoButton()
    }
    @IBAction func submitButton(_ sender: UIButton) {
        viewModel.checkValidation(emailTextField: emailTextField)
    }
}
