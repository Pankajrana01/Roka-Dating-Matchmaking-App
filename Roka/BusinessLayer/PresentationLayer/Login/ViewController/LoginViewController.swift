//
//  LoginViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import UIKit

class LoginViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.login
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.login
    }

    lazy var viewModel: LoginViewModel = LoginViewModel(hostViewController: self)
    
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

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var counrtyCodeTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        showNavigationLogoinCenter()

        //viewModel.counrtyCodeTextField = counrtyCodeTextField
        viewModel.phoneNumberTextField = phoneNumberTextField
        
        phoneNumberTextField.delegate = self
        //counrtyCodeTextField.delegate = self
        
       // counrtyCodeTextField.text = viewModel.countryCode
        //counrtyCodeTextField.addTarget(self, action: #selector(countryCodeTapped(_:)), for: .touchDown)
        
        self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode, UIImage(named: "ic_dropdown") as Any],
                                           target: self.viewModel,
                                           selector: #selector(viewModel.selectCountryTapped))

        self.viewModel.countryCodeUpated = {
            self.phoneNumberTextField.addLeftButton(accessories: [self.viewModel.countryCode,  UIImage(named: "ic_dropdown") as Any],
                                                    target: self.viewModel,
                                                    selector: #selector(self.viewModel.selectCountryTapped))
        }
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "1234567890",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.appBorderColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
        
        
        viewModel.enableDisableNextButton(nextButton: nextButton, phoneNumberTextField: phoneNumberTextField)

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeNavigationBar()
        }
    }
    
    @objc func countryCodeTapped(_ textField: UITextField){
        viewModel.proceedForSelectCountry()
    }
    
    @IBAction func recoverButtonAction(_ sender: UIButton) {
        viewModel.proceedToRecoverPasswordScreen()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.checkValidation(phoneTextField: self.phoneNumberTextField)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        viewModel.proceedToRegisterScreen()
    }
    
}

// MARK: - UITextField Delegates.
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
        
       // return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.enableDisableNextButton(nextButton: nextButton, phoneNumberTextField: phoneNumberTextField)
    }

}
