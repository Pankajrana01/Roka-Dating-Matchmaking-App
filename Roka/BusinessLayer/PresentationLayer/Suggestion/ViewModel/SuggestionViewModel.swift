//
//  SuggestionViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit

class SuggestionViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
}

// MARK:-
// MARK:- add validations
extension SuggestionViewModel{
    func checkValidation(nameTextField: UITextField, suggestionTextView:UITextView){
        if let params = validateModelWithUserInputs(nameTextField: nameTextField, suggestionTextView:suggestionTextView) {
            print(params)
            self.processForBasicInfoData(params: params)
        }
    }
    
    func validateModelWithUserInputs(nameTextField: UITextField, suggestionTextView:UITextView) -> [String: Any]? {
        let firstName = nameTextField.text?.trimmed ?? ""
        let suggestion = suggestionTextView.text ?? ""
        
//        if firstName.isEmpty {
//            nameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.emptyName)
//            return nil
//        }
//        else if firstName.count < 3 || firstName.count > 30 {
//            nameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.invalidFullNameCount)
//            return nil
//        }
//        else
        if suggestion.isEmpty || suggestion == "Write here..."{
            suggestionTextView.becomeFirstResponder()
            showMessage(with: ValidationError.emptySuggestion)
            return nil
        }
        
        var params = [String:Any]()
       // params[WebConstants.name] = firstName
        params[WebConstants.description] = suggestion
        params["userType"] = "\(GlobalVariables.shared.selectedProfileMode != "MatchMaking" ? 1 : 2)"
        return params
    }
    
    // MARK: - API Call...
    func processForBasicInfoData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.suggestion,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.suggestionSubmit)
                delay(1){
                    self.hostViewController.navigationController?.popViewController(animated: true)
                }
            }
            hideLoader()
        }
    }
}
