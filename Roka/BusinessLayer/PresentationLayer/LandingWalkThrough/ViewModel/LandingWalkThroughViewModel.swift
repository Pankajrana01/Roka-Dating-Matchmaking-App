//
//  LandingWalkThroughViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit
class LandingWalkThroughViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var isCome = ""
    
    
    func proceedForHome() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    
    func proceedForCreateMatchMakingProfile() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
}
