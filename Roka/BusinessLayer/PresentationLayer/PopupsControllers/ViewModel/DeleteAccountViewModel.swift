//
//  DeleteAccountViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/11/22.
//

import Foundation
import UIKit

class DeleteAccountViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    weak var confirmTextField: UITextField!
    
    var isComeFrom = ""
    var friendId = ""
    var callbacktopreviousscreen: (() ->())?
    
    fileprivate func logoutSuccess() {
        KUSERMODEL.logoutUser()
        gotoLoginScreen()
    }
 
    // MARK: - API Call...
    func processForDeleteUserData( _ result: @escaping(String?) -> Void) {
        if confirmTextField.text == "" {
            showMessage(with: "Please enter CONFIRM text")
        } else if confirmTextField.text?.uppercased() != "CONFIRM" {
            showMessage(with: "Please enter correct text")
        } else {
            showLoader()
            ApiManager.makeApiCall(APIUrl.User.basePreFix,
                                   headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                                   method: .delete) { response, _ in
                if !self.hasErrorIn(response) {
                    let responseData = response![APIConstants.data] as! [String: Any]
                    self.logoutSuccess()
                    
                }
                hideLoader()
            }
        }
    }
    
    
    func processForDeleteFriendProfile(id: String, _ result:@escaping(String?) -> Void) {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.id] = id
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.deleteMatchMakingUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                showSuccessMessage(with: "Profile deleted successfully")
                result("yes")
            }
            hideLoader()
        }
    }
}
