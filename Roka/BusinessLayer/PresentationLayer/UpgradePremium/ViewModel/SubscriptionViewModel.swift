//
//  SubscriptionViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit
import StoreKit

class SubscriptionViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
    func proceedForBuyPremiumScreen() {
        BuyPremiumViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    // MARK: - API Call...
    func getSubscriptionApiCall(_ result:@escaping([[String: Any]]?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.InAppPurchase.mySubscriptions,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let responseData = response![APIConstants.data] as? [[String: Any]] {
                                        result(responseData)
                                    }
                                }
            hideLoader()
        }
    }
   
}

