//
//  NewSearchApplyViewModel.swift
//  Roka
//
//  Created by  Developer on 04/11/22.
//

import Foundation

class NewSearchApplyViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    
    var filteredData: [String: Any] = [:]
    
//    func proceedForPreference() {
//        PreferencesViewController.show(from: self.hostViewController, forcePresent: true, isComeFor: "") { success in }
//    }
    
    var preferenceId = ""
    
    // MARK: - API Call...
    func processUserSearchPreferences(params: [String: Any], _ completion: @escaping(String?) -> Void) {
        showLoader()
        var params = params
        if !preferenceId.isEmpty {
            params["id"] = preferenceId
        }
        params["userType"] = GlobalVariables.shared.selectedProfileMode != "MatchMaking" ? 1 : 2
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.userSearchPreferences,
                               params: params,
                               headers: headers,
                               method: !preferenceId.isEmpty ? .put : .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                print(responseData)
                if let first = self.hostViewController.presentingViewController?.presentingViewController {
                    first.dismiss(animated: true)
                }
                if !self.preferenceId.isEmpty {
                    showSuccessMessage(with: StringConstants.editSuccessfully)
                    completion("success")
                } else {
                    showSuccessMessage(with: StringConstants.savedSuccessfully)
                    completion("success")
                }
            }
            hideLoader()
        }
    }
    
}
