//
//  SecretCodeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import UIKit

class SecretCodeViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.signup
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.secret
    }

    lazy var viewModel: SecretCodeViewModel = SecretCodeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    phoneNumber: String,
                    countryCode: String,
                    isComeFrom : String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SecretCodeViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.phoneNumber = phoneNumber
        controller.viewModel.countryCode = countryCode
        controller.viewModel.isComeFrom = isComeFrom
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var pinViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resendStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
       
//        if height >= 812 {
//            self.pinViewLeadingConstraint.constant = -25
//        } else {
//            self.pinViewLeadingConstraint.constant = -50
//        }
        
        showNavigationLogoforSecretCodeScreen()
        viewModel.pinView = pinView
        viewModel.timeLabel = timeLabel
        viewModel.resendStackView = resendStackView
        viewModel.timeStackView = timeStackView
        viewModel.verifyButton = verifyButton
        self.phoneNumberLabel.text = "\(viewModel.countryCode) " + viewModel.phoneNumber
        viewModel.configurePinView()
        viewModel.enableDisableNextButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewAppeared()
    }
    
    @IBAction func verifyNoButtonAction(_ sender: UIButton) {
        viewModel.otpFilled()
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        viewModel.resendButtonTapped()
    }
    
    @IBAction func editPhoneNumber(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
