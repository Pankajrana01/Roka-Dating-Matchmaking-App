//
//  ReferAndEarnViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import Foundation
import UIKit

class ReferAndEarnViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    func proceedForCongratulationScreen() {
        CongratsViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
 
    // MARK: - API Call...
    func getReferAndEarnData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.getUserReferralCode,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    result(responseData)
                                }
            hideLoader()
        }
    }
}
