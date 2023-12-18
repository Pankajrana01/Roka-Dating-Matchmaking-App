//
//  SecretCodeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import Foundation
import UIKit
import CountryPickerView

class SecretCodeViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var user = UserModel.shared.user
    var phoneNumber = ""
    var countryCode = ""
    var pinView: SVPinView!
    var timeLabel: UILabel!
    var resendStackView: UIStackView!
    var timeStackView: UIStackView!
    var verifyButton: UIButton!
    var waitingTime: Int = 30
    var enterPin = ""
    var isComeFrom = ""
    private var timerTime: Int = 30
    private lazy var timeLeft = timerTime
    private var timerStartDate: Date?
  
    func enableDisableNextButton() {
        if self.enterPin == "" {
            self.verifyButton.alpha = 0.5
            self.verifyButton.isUserInteractionEnabled = false
        } else {
            self.verifyButton.alpha = 1.0
            self.verifyButton.isUserInteractionEnabled = true
        }
    }
    
    func configurePinView() {
        pinView.pinLength = 4
        pinView.interSpace = 20
        pinView.textColor = UIColor.appTitleBlueColor
        pinView.borderLineColor = .lightGray
        pinView.activeBorderLineColor = UIColor.appLightGray
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 2
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = true
        pinView.style = .box
        pinView.fieldBackgroundColor = .white
        pinView.activeFieldBackgroundColor = .white
        pinView.fieldCornerRadius = 5
        pinView.activeFieldCornerRadius = 5
        pinView.placeholder = "----"
        pinView.deleteButtonAction = .deleteCurrent
        pinView.keyboardAppearance = .default
        pinView.tintColor = UIColor.appBorder
        pinView.keyboardType = .numberPad
        pinView.becomeFirstResponderAtIndex = 0
        //pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont(name: "SharpSansTRIAL-Semibold", size: 20.0)!
 
        pinView.didChangeCallback = { pin in
            print("\(pin)")
            if pin.count == 4 {
                self.hostViewController.view.endEditing(true)
                self.enterPin = "\(pin)"
                //self.viewModel.otpFilled(otpText: pin)
                self.enableDisableNextButton()
            } else {
                self.enterPin = ""
                self.enableDisableNextButton()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.hostViewController.view.endEditing(false)
    }
    
    // MARK: -
    // MARK: = to tap on resend button ...
    func resendButtonTapped() {
        if self.timeLeft == 0 {
            var params = [String: Any]()
            params[WebConstants.countryCode] = self.countryCode
            params[WebConstants.phoneNumber] = self.phoneNumber
            self.processForResendOTPData(params: params)
            
        }
    }
    
    func proceedToSelectUserProfileScreen() {
        KAPPDELEGATE.initializeDatingNavigationBar()
        GlobalVariables.shared.selectedProfileMode = "Dating"
        AppDelegate.shared.updateRootController(SelectUserProfileViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedForHomeWalkThroughScreen() {
        KAPPDELEGATE.initializeDatingNavigationBar()
        GlobalVariables.shared.selectedProfileMode = "Dating"
        AppDelegate.shared.updateRootController(HomeWalkThroughViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedToBasicInfoScreen() {
        KAPPDELEGATE.initializeDatingNavigationBar()
        GlobalVariables.shared.selectedProfileMode = "Dating"
        AppDelegate.shared.updateRootController(BasicInfoViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedForListingMatchMaking() {
        KAPPDELEGATE.initializeMatchMakingNavigationBar()
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForHome() {
        KAPPDELEGATE.initializeDatingNavigationBar()
        GlobalVariables.shared.selectedProfileMode = "Dating"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedToNextScreen() {
        let registrationStep = Int(KAPPSTORAGE.registrationStep) ?? -1
        let userType = Int(KAPPSTORAGE.userType) ?? 1
        let isDeactivate = Int(KAPPSTORAGE.isDeactivate) ?? 0

        if isComeFrom == "Login" {
            if registrationStep == 1 {
                if userType == 1 {
                    proceedToBasicInfoScreen()
                } else if userType == 2 {
                    proceedForListingMatchMaking()
                } else {
                    proceedToBasicInfoScreen()
                }
            } else if registrationStep == 2 {
                if userType == 1 {
                    if isDeactivate == 1 {
                        proceedForListingMatchMaking()
                    } else {
                        proceedForHome()
                    }
                } else if userType == 2 {
                    proceedForListingMatchMaking()
                } else {
                    proceedToBasicInfoScreen()
                }
            }
            else {
                proceedToBasicInfoScreen()
            }
        } else {
            KAPPDELEGATE.initializeDatingNavigationBar()
            BasicInfoViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: isComeFrom) { success in
                
            }
        }
    }

    // MARK: - to fill otp ...
    func otpFilled() {
        if let params = self.validateModelWith(otpTextField: self.enterPin) {
            self.processForVerifyOTPData(params: params)
        }
    }

    func validateModelWith(otpTextField: String) -> [String: Any]? {
        let otp = otpTextField
        var params = [String: Any]()
        params[WebConstants.countryCode] = self.countryCode
        params[WebConstants.phoneNumber] = self.phoneNumber
        params[WebConstants.otp] = otp
        return params
    }
    
    // MARK: - API Call...
    func processForVerifyOTPData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.verifyPhoneNumber,
                               params: params,
                               headers: nil,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    //if self.isComeFrom == "Login"{
                                        KAPPSTORAGE.user = self.user
                                        UserModel.shared.storedUser = self.user
                                    
                                    //}
                                    
                                    self.proceedToNextScreen()

                                }
                                hideLoader()
        }
    }
    
    func processForResendOTPData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.resendOtpForVerification,
                               params: params,
                               headers: nil,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    self.resendStackView.isHidden = true
                                    self.startTimer()
                                    self.pinView.clearPin()
                                    self.enterPin = ""

                                }
                                hideLoader()
        }
    }
}


// MARK: - to process data ...

extension SecretCodeViewModel {
    func viewAppeared() {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterForeground),
                                               name: .appEnterForeground,
                                               object: nil)
        timerTime = 30
        self.startTimer()
        self.resendStackView.isHidden = true
    }
    @objc
    func appEnterForeground() {
        
        if let timerStartDate = timerStartDate {
            timeLeft = timerTime - Int(Date().timeIntervalSince(timerStartDate))
        }
    }
    func viewDisAppeared() {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        stopTimer()
    }

    func stopTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.timeLeft = 0
        timerStartDate = nil
        NotificationCenter.default.removeObserver(self)
    }

    func startTimer() {
        if timerStartDate == nil {
            timeLeft = timerTime
            if timeLeft > 0 {
                if timeLeft > 9 {
                    timeLabel.text = getTimeLeftString()
                } else {
                    timeLabel.text = getTimeLeftString()
                }
                resendStackView?.isHidden = true
            } else {
                resendStackView?.isHidden = false
            }
            timerStartDate = Date()
        }
        self.perform(#selector(self.updateTimer), with: nil, afterDelay: 1, inModes: [RunLoop.Mode.default])
    }

    @objc
    func updateTimeLeft() {
        if let timerStartDate = timerStartDate {
            timeLeft = timerTime - Int(Date().timeIntervalSince(timerStartDate))
        }
    }
    
    @objc
    func updateTimer() {
        if timeLeft > 0 {
            resendStackView?.isHidden = true
            self.timeLeft -= 1
            if timeLeft > 9 {
                timeLabel.text = getTimeLeftString()
            } else {
                timeLabel.text = getTimeLeftString()
            }
            self.perform(#selector(self.updateTimer), with: nil, afterDelay: 1, inModes: [RunLoop.Mode.default])
        } else {
            self.timeLeft = 0
            timerStartDate = nil
            resendStackView.isHidden = false
        }
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func getTimeLeftString() -> String {
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: timeLeft)
        let hString = h > 9 ? "\(h)" : "0\(h)"
        let mString = m > 9 ? "\(m)" : "0\(m)"
        let sString = s > 9 ? "\(s)" : "0\(s)"

        if h > 0 {
            return "\(hString):\(mString):\(sString)"
        } else {
            return "\(mString):\(sString) sec"
        }
    }
}

// MARK: - UITextField Delegates.
extension SecretCodeViewModel: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableDisableNextButton()
    }

}


