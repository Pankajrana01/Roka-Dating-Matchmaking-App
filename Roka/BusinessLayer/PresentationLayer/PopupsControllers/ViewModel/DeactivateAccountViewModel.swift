//
//  DeactivateAccountViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 04/04/23.
//

import Foundation
import UIKit
import CoreLocation

class DeactivateAccountViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var isComeFor = ""
    var isDeactivate = 0
    
    
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
                        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
//                            showMessage(with: "Account deactivated successfully", theme: .success)
                        } else {
//                            showMessage(with: "Account deactivated successfully", theme: .success)
                        }
//                        if self.isComeFor == "DatingProfile" {
//                            showMessage(with: "Account deactivated successfully", theme: .success)
//                        } else {
//                            showMessage(with: "Account activated successfully", theme: .success)
//                        }
                    }
                }
            }
            hideLoader()
        }
    }
    
}
