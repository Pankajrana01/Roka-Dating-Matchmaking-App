//
//  WalkThroughViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import UIKit

class WalkThroughViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.walkthrough
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.walkthrough
    }

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var logoView: UIImageView!
    @IBOutlet private weak var logoStackView: UIStackView!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
        
    lazy var viewModel: WalkThroughViewModel = WalkThroughViewModel(hostViewController: self)
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.topImageView.alpha = 0
        self.bottomStackView.alpha = 0
        self.logoStackView.alpha = 1
        self.descLabel.alpha = 0
        initializeUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: Notification.Name("appEnterForeground"), object: nil)
    }
    
    func initializeUI() {
        viewModel.logoImageView = logoImageView
        viewModel.topImageView = topImageView
        viewModel.logoView = logoView
        viewModel.logoStackView = logoStackView
        viewModel.descLabel = descLabel
        viewModel.bottomStackView = bottomStackView
        viewModel.loginButton = loginButton
        viewModel.registerButton = registerButton
        viewModel.processForGetVersionData()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func didBecomeActive() {
        // animations were disturbed, now fix views positions without animation
        viewModel.animationDuration = 0
        viewModel.performAnimtaion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(1) {
            self.viewModel.performAnimtaion()
        }
    }

    @IBAction func registerButtonAction(_ sender: UIButton) {
        viewModel.proceedToRegisterScreen()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        viewModel.proceedToLoginScreen()
    }
    
    
}
