//
//  LogoutViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 03/10/22.
//

import Foundation
import UIKit

class LogoutViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    
    fileprivate func logoutSuccess() {
        KUSERMODEL.logoutUser()
        gotoLoginScreen()
    }
    
    func processForLogoutData() {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.deviceToken] = KAPPSTORAGE.fcmToken
        ApiManager.makeApiCall(APIUrl.UserApis.logout,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                self.logoutSuccess()
            }
            hideLoader()
        }
    }
    
}
