//
//  SearchViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

class SearchViewModel: BaseViewModel {
    var isComeFor = ""
    var profileCount = ""
    var completionHandler: ((Bool) -> Void)?
    // array declaration.
    var preferenceIds: [String] = []
   
    func proceedForNewSearch(preferenceId: String = "") {
        NewSearchViewController.show(from: self.hostViewController, forcePresent: true, isComeFor: "Search", preferenceId: preferenceId) { success in
            print("Dhiraj")
        }
    }
    
    func proceedForSearchDetailsPager(id:String, name:String, isCome:String) {
        SearchDetailsPagerController.show(from: self.hostViewController, forcePresent: false, isCome: isCome, id: id, profileCount: profileCount, titleName: name)
    }
    
    func proceedForSwitchModeScreen() {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            let controller = SwitchModeViewController.getController() as! SwitchModeViewController
            controller.dismissCompletion = { value  in }
            controller.show(over: self.hostViewController, isComeFor: "Dating") { value in
            }
        } else {
            let controller = SwitchModeViewController.getController() as! SwitchModeViewController
            controller.dismissCompletion = { value  in }
            controller.show(over: self.hostViewController, isComeFor: "MatchMaking") { value in
            }
        }
    }
    
    // MARK: - API Call...
    func getSearchPreferenceData(_ result: @escaping([[String: Any]]?) -> Void) {
        let url = APIUrl.UserApis.userSearchPreferences + "?userType=\(GlobalVariables.shared.selectedProfileMode != "MatchMaking" ? 1 : 2)"
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(url,
                               headers: headers,
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [[String: Any]]
                result(responseData)
            }
            hideLoader()
        }
    }
    
    
    // MARK: - API Call...
    func deleteSavedPreferences(params: [String: String], result: @escaping () -> ()) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.userSearchPreferences,
                               params: params,
                               headers: headers,
                               method: .delete) { response, _ in
            if !self.hasErrorIn(response) {
                let status = response![APIConstants.status] as! Int
                self.preferenceIds.removeAll()
                if status == 200 {
                    result()
                }
            }
            hideLoader()
        }
    }
}

