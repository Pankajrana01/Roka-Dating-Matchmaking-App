//
//  SignupViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import UIKit

class SignupViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.signup
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.signup
    }
    
    lazy var viewModel: SignupViewModel = SignupViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override class func show(from viewController: UIViewController,
                             forcePresent: Bool = true) {
        self.getController().show(from: viewController,
                                  forcePresent: forcePresent)
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SignupViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var inValidCodeLable: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var counrtyCodeTextField: UnderlinedTextField!
    @IBOutlet weak var referralCodeTextView: UIView!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var termLable: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    private var tapGesture = UITapGestureRecognizer()
    private var termsRange = NSRange()
    private var privacyRange = NSRange()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeNavigationBar()
        }
        self.codeButton.isHidden = true
        showNavigationLogoinCenter()
        addTapGesture()
        addNavigationBackButton()
        viewModel.phoneNumberTextField = phoneNumberTextField
       // viewModel.counrtyCodeTextField = counrtyCodeTextField
        viewModel.referralCodeTextField = referralCodeTextField
        viewModel.inValidCodeLable = inValidCodeLable
        viewModel.referralCodeTextView = referralCodeTextView
        viewModel.codeButton = codeButton
        self.inValidCodeLable.isHidden = true
        viewModel.nextButton = nextButton
        viewModel.phoneNumberTextField.delegate = viewModel
        //viewModel.counrtyCodeTextField.delegate = viewModel
        viewModel.referralCodeTextField.delegate = viewModel
        
        
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
        
        //counrtyCodeTextField.text = viewModel.countryCode
       // counrtyCodeTextField.addTarget(self, action: #selector(countryCodeTapped(_:)), for: .touchDown)
        viewModel.enableDisableNextButton()
    }
    @objc func countryCodeTapped(_ textField: UITextField){
        viewModel.proceedForSelectCountry()
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton) {
        viewModel.proceedToPreviousScreen()
    }
    
    @IBAction func codeButton(_ sender: Any) {
        
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.checkValidation(phoneTextField: self.phoneNumberTextField, referralTextField: referralCodeTextField)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        viewModel.proceedToLoginScreen()
    }
    
    @IBAction func checkButtonAction(_ sender: UIButton) {
        if viewModel.isTermsConditionSelected == false {
            self.checkButton.setImage(UIImage(named: "Ic_selected_tick"), for: .normal)
            viewModel.isTermsConditionSelected = true
            viewModel.enableDisableNextButton()
        } else {
            self.checkButton.setImage(UIImage(named: "UnSelectRectangle"), for: .normal)
            viewModel.isTermsConditionSelected = false
            viewModel.enableDisableNextButton()
        }
    }
    
    //I agree to Roka's Terms & Conditions and Privacy Policy
    
    func addTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action:
                                                #selector(SignupViewController.handleTap(sender:)))
        tapGesture.delegate = self
        let text = (self.termLable.text)!
        
        termsRange = (text as NSString).range(of: "terms of use")
        
        privacyRange = (text as NSString).range(of: "privacy policy")
        
        self.termLable.isUserInteractionEnabled = true
        self.termLable.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if (sender?.didTapAttributedTextInLabel(label: self.termLable, inRange: termsRange))! {
            self.viewModel.proceedForTermsConditionsScreen()
            
        } else if (sender?.didTapAttributedTextInLabel(label: self.termLable, inRange: privacyRange))! {
            self.viewModel.proceedForPrivacyScreen()
            
        } else {
            print("Tapped none")
        }
    }
    
}
