//
//  HelpViewModel.swift
//  Roka
//
//  Created by  Developer on 01/11/22.
//

import Foundation
import UIKit

class HelpViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    // MARK: - API Call...
    func processForGetUserData(_ result:@escaping([String: Any]?) -> Void) {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    DispatchQueue.main.async {
                                        let responseData = response![APIConstants.data] as! [String: Any]
                                        self.user.updateWith(responseData)
                                        result(responseData)
                                    }
                                }
            hideLoader()
        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: headers,
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    let userResponseData = response![APIConstants.data] as! [String: Any]
                    result(userResponseData)
                    
                }
                hideLoader()
            }
        }
    }
    
    func processForDeActivateProfile(isDeactivate: Int, _ result:@escaping(String?) -> Void) {
        showLoader()
        var params = [String:Any]()
        params["isDeactivate"] = isDeactivate
        ApiManager.makeApiCall(APIUrl.UserApis.activateDeactivate,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                if let message = response![APIConstants.message] as? String {
                    if message == "success" {
                        result("yes")
                    }
                }
            }
            hideLoader()
        }
    }
}
