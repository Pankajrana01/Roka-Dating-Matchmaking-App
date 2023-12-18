//
//  LoginViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit
import CountryPickerView

class LoginViewModel: BaseViewModel {
    var phoneNumberTextField: UITextField!
    var counrtyCodeTextField: UnderlinedTextField!

    var user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    
    lazy var countryCode: String = self.getCountryCode()
    var countryCodeUpated: (()->Void)?
    var phoneNumString = ""
    
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
        self.proceedForSelectCountry()
    }
    
    func showCountryPicker() {
        cpv.showCountriesList(from: hostViewController)
    }
    
    func enableDisableNextButton(nextButton: UIButton, phoneNumberTextField: UITextField){
        let phone = phoneNumberTextField.text ?? ""
        if phone == "" || phone.count < 10 {
           nextButton.alpha = 0.5
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.alpha = 1.0
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    func proceedForSelectCountry() {
        let controller = SelectCountryViewController.getController() as! SelectCountryViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isCurrentCountryCode: self.countryCode) { value in
            self.countryCode = value
            self.countryCodeUpated?()
           // self.counrtyCodeTextField.text = value
        }
    }
    
    func proceedToRecoverPasswordScreen() {
        let contorller = RecoverViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToLoginScreen() {
        let contorller = LoginViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToRegisterScreen() {
        let viewControllers: [UIViewController] = self.hostViewController.navigationController!.viewControllers
        let lastController = viewControllers.last
        let secLastController = viewControllers[viewControllers.count-2]
        
        if lastController is SignupViewController {
            self.hostViewController.navigationController?.popViewController(animated: true)
        } else if secLastController is SignupViewController {
            self.hostViewController.navigationController?.popViewController(animated: true)
        } else {
            let contorller = SignupViewController.getController()
            contorller.show(from: self.hostViewController)
        }
    }
    
    func proceedToVerifyScreen() {
        SecretCodeViewController.show(from: self.hostViewController, forcePresent: false, phoneNumber: phoneNumberTextField.text ?? "", countryCode: self.countryCode, isComeFrom: "Login") { success in
        }
    }
}

// MARK:-
// MARK:- add validations
extension LoginViewModel{
    func checkValidation(phoneTextField: UITextField){
        if let params = validateModelWithUserInputs(phoneTextField: phoneTextField) {
            print(params)
            self.processForLoginData(params: params)
        }
    }
    
    func validateModelWithUserInputs(phoneTextField: UITextField) -> [String: Any]? {
        let phone = phoneTextField.text?.trimmed ?? ""
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
    
        let numberAsInt = Int(phone)
        let backToString = "\(numberAsInt!)"
        print(backToString)
        var params = [String:Any]()
        params[WebConstants.countryCode] = self.countryCode
        params[WebConstants.emailOrPhoneNumber] = backToString.trimmed
        params[WebConstants.platform] = Platform.iOS.rawValue
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        return params
    }
    
    // MARK: - API Call...
    func processForLoginData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.login,
                               params: params,
                               headers: nil,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
//                                    let responseData = response![APIConstants.data] as! [String: Any]
//                                    self.user.updateWith(responseData)
//                                    KUSERMODEL.setUserLoggedIn(true)
                                    self.proceedToVerifyScreen()
                                }
                                hideLoader()
        }
    }
}

// MARK: - Country picker Delegate
extension LoginViewModel: CountryPickerViewDelegate, CountryPickerViewDataSource {
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

