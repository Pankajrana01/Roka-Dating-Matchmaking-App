//
//  RecoverViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import Foundation
import UIKit

class RecoverViewModel: BaseViewModel {
    var emailTextField: UITextField!
    var sendButton: UIButton!
    var sendButtonBottomConstraints: NSLayoutConstraint!
    private var scrollView = UIScrollView()
    
    
    func recoveryEmailInfoButton() {
        let controller = RecoveryEmailViewController.getController() as! RecoveryEmailViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { }
    }
    
    func initializeKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = self.hostViewController.view.convert(keyboardScreenEndFrame, from: self.hostViewController.view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.sendButtonBottomConstraints.constant = 20
        } else {
            self.sendButtonBottomConstraints.constant = keyboardViewEndFrame.height
        }
        
        // Get required info out of the notification
        if let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = self.hostViewController.view.convert((endValue as AnyObject).cgRectValue, from: self.hostViewController.view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.hostViewController.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
}

// MARK:-
// MARK:- add validations
extension RecoverViewModel{
    func checkValidation(emailTextField: UITextField){
        if let params = validateModelWithUserInputs(emailTextField: emailTextField) {
            print(params)
            self.processForRecoveryEmailData(params: params)
        }
    }
    
    func validateModelWithUserInputs(emailTextField: UITextField) -> [String: Any]? {
        let emailAddress = emailTextField.text?.trimmed ?? ""
        
        if emailAddress.isEmpty {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
            return nil
        }
        else if emailAddress.isValidEmailAddress == false {
            emailTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        
        var params = [String:Any]()
        params[WebConstants.email] = emailAddress
       
        return params
    }
    
    // MARK: - API Call...
    func processForRecoveryEmailData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.accountRecovery,
                               params: params,
                               headers: nil,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showSuccessMessage(with: SucessMessage.forgotSuccess)
                                }
                                self.emailTextField.text = ""
                                hideLoader()
        }
    }
    
}
