//
//  AddLinksViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import Foundation
import UIKit

class AddLinksViewModel:BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var isCome = ""
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
    // MARK: - API Call...
    func processForUpdateProfileApiData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: StringConstants.updatedProfile)
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    result("success")
                                }
            
                                hideLoader()
        }
    }
    
}
