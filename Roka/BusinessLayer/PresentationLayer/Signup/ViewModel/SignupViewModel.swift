//
//  SignupViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import Foundation
import UIKit
import CountryPickerView

class SignupViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var phoneNumberTextField: UITextField!
    var counrtyCodeTextField: UnderlinedTextField!
    var referralCodeTextField: UITextField!
    var nextButton: UIButton!
    var inValidCodeLable: UILabel!
    var checkButton: UIButton!
    var termLable: UILabel!
    var codeButton: UIButton!
    var referralCodeTextView: UIView!
    lazy var countryCode: String = self.getCountryCode()
    var countryCodeUpated: (()->Void)?
    var referralUserId = ""
    var user = UserModel.shared.user
    var isTermsConditionSelected = false
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        return countryPickerView
    }()
    
    private func getCountryCode() -> String {
//        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
//            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
//            return code
//        }
//        else
        if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
            return code
        }
        return "N.A."
    }
    @objc
    func selectCountryTapped() {
        //cpv.defaultSelectedCountryCode = self.countryCode
       // self.showCountryPicker()
        self.proceedForSelectCountry()
    }
    
    func showCountryPicker() {
        cpv.showCountriesList(from: hostViewController)
    }
    
    func proceedForSelectCountry() {
        let controller = SelectCountryViewController.getController() as! SelectCountryViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isCurrentCountryCode: self.countryCode) { value in
            self.countryCode = value
           // self.counrtyCodeTextField.text = value
            self.countryCodeUpated?()
        }
    }
    
    func enableDisableNextButton() {
        let phone = phoneNumberTextField.text ?? ""
        if phone == "" || phone.count < 10 || isTermsConditionSelected == false {
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.alpha = 0.5
        } else {
           self.nextButton.alpha = 1.0
            self.nextButton.isUserInteractionEnabled = true
        }
    }
    
    func proceedToRecoverPasswordScreen() {
        let contorller = RecoverViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToLoginScreen() {
        let viewControllers: [UIViewController] = self.hostViewController.navigationController!.viewControllers
        let lastController = viewControllers.last
        let secLastController = viewControllers[viewControllers.count-2]
        
        if lastController is LoginViewController {
            self.hostViewController.navigationController?.popViewController(animated: true)
        } else if secLastController is LoginViewController {
            self.hostViewController.navigationController?.popViewController(animated: true)
        } else  {
            let contorller = LoginViewController.getController()
            contorller.show(from: self.hostViewController)
        }
    }
    
    func proceedToRegisterScreen() {
        let contorller = SignupViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToVerifyScreen() {
        SecretCodeViewController.show(from: self.hostViewController, forcePresent: false, phoneNumber: phoneNumberTextField.text ?? "", countryCode: self.countryCode, isComeFrom: isComeFor) { success in
        }
    }
}

// MARK:-
// MARK:- add validations
extension SignupViewModel {
    func checkValidation(phoneTextField: UITextField, referralTextField: UITextField){
        if let params = validateModelWithUserInputs(phoneTextField: phoneTextField, referralTextField: referralTextField) {
            print(params)
            processForRegisterData(params: params)
        }
    }
    
    func validateModelWithUserInputs(phoneTextField: UITextField, referralTextField: UITextField) -> [String: Any]? {
        
        let phone = phoneTextField.text?.trimmed ?? ""
        let referralCode = referralTextField.text?.trimmed ?? ""
        
        if self.countryCode == ""{
            showMessage(with: ValidationError.selectCountryCode)
            return nil
        }
        else if phone.isEmpty {
            phoneTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPhoneNumber)
            return nil
        }
        else if phone.first == "0"{
            showMessage(with: ValidationError.invalidPhoneNumberWithZeroStart)
            return nil
        }
        else if phone.isValidMobileNumber == false {
            phoneTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidPhoneNumber)
            return nil
        }
        else if isTermsConditionSelected == false {
            showMessage(with: ValidationError.checkTermsAndPrivacy)
            return nil
        }
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt!)"
        print(backToString)
        
        var params = [String:Any]()
        params[WebConstants.countryCode] = self.countryCode
        params[WebConstants.phoneNumber] = backToString.trimmed
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
       
        if isComeFor == "MatchMaking" {
            params[WebConstants.userType] = "2"
        } else {
            params[WebConstants.userType] = "1"
        }
        
        if self.referralUserId != "" {
            params[WebConstants.referralCode] = referralCode
            params[WebConstants.referredBy] = self.referralUserId
        }
        return params
    }
    
    // MARK: - API Call...
    func processForRegisterData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.register,
                               params: params,
                               headers: nil,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    // let responseData = response![APIConstants.data] as! [String: Any]
                                   // self.user.updateWith(responseData)
//                                    KUSERMODEL.setUserLoggedIn(true)
                                  //  KUSERMODEL.selectedProfileIndex = 0
                                    self.proceedToVerifyScreen()

                                }
                                hideLoader()
        }
    }
    
    func processForVerifyReferralData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.verifyReferralCode,
                               params: params,
                               headers: nil,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                  //  self.referralCodeTextField.rightImage = UIImage(named: "ic_tick")
                                    self.codeButton.isHidden = false
                                    self.inValidCodeLable.isHidden = true
                                    self.referralCodeTextView.layer.borderColor = UIColor.loginBlueColor.cgColor
                                    self.referralCodeTextView.clipsToBounds = true
                                    self.codeButton.setImage(UIImage(named: "ic_tick"), for: .normal)
                                    if let userId = responseData[WebConstants.userId] as? String {
                                        self.referralUserId = userId
                                    }
                                } else {
                                    self.referralUserId = ""
                                    self.codeButton.isHidden = false
                                    self.inValidCodeLable.isHidden = false
                                    self.referralCodeTextView.layer.borderColor = UIColor.appBorderColor.cgColor
                                    self.referralCodeTextView.clipsToBounds = true
                                    self.codeButton.setImage(UIImage(named: "cross-mark"), for: .normal)
                                  //  self.referralCodeTextField.rightImage = UIImage(named: "cross-mark")
                                    rightPaddingClick = { tag in
                                        self.crossButtonAction()
                                    }
                                }
                                hideLoader()
        }
    }
    
    func crossButtonAction() {
//        if self.referralCodeTextField.rightImage == UIImage(named: "cross-mark") {
//            self.referralCodeTextField.text = ""
//            self.referralCodeTextField.rightImage = nil
//            self.inValidCodeLable.isHidden = true
//        }
    }
    
    func proceedForPrivacyScreen() {
        WebPageViewController.show(from: self.hostViewController, forcePresent: false, title: "Privacy", url: APIUrl.GeneralUrls.privacyPolicy, iscomeFrom: "Profile") { success in
        }
    }
    
    func proceedForTermsConditionsScreen() {
        WebPageViewController.show(from: self.hostViewController, forcePresent: false, title: "Terms and conditions", url: APIUrl.GeneralUrls.termsAndConditions, iscomeFrom: "Profile") { success in
        }
    }
    
    func proceedToPreviousScreen() {
        KAPPDELEGATE.updateRootController(WelcomeViewController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
    }
}

// MARK: - Country picker Delegate
extension SignupViewModel: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
        self.countryCode = country.phoneCode
        self.countryCodeUpated?()
        self.counrtyCodeTextField.text = self.countryCode
    }
}
// MARK: - UITextField Delegates.
extension SignupViewModel: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == referralCodeTextField {
            if (textField.text?.count ?? 0) + (string.count - range.length) == 6 {
                var param = [String:Any]()
                param[WebConstants.referralCode] = referralCodeTextField.text! + string
                self.processForVerifyReferralData(params: param)
               
            } else {
                //referralCodeTextField.rightImage = nil
                self.codeButton.isHidden = true
                self.referralCodeTextView.layer.borderColor = UIColor.appBorderColor.cgColor
                self.inValidCodeLable.isHidden = true

            }
            
            return (textField.text?.count ?? 0) + (string.count - range.length) <= 6
        } else {
            let maxLength = 10
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
//        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableDisableNextButton()
    }

}
