//
//  SplashViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit

class SplashViewModel: BaseViewModel {
    var user = UserModel.shared.user

    func proceedToNextScreen() {
        AppDelegate.shared.updateRootController(WelcomeViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedToSelectUserProfileScreen() {
        AppDelegate.shared.updateRootController(SelectUserProfileViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedToStepOneViewController() {
        KAPPDELEGATE.updateRootController(StepOneViewController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedToBasicInfoScreen() {
        AppDelegate.shared.updateRootController(BasicInfoViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedForHomeWalkThroughScreen() {
        AppDelegate.shared.updateRootController(HomeWalkThroughViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    
    func proceedForHome() { //TabBarController //ProfileCreatedViewController
        GlobalVariables.shared.selectedProfileMode = "Dating"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForMatchMakingWalkThrough() {
        KAPPDELEGATE.updateRootController(HomeWalkThroughViewController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForListingMatchMaking() {
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeMatchMakingNavigationBar()
        }
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForCreateMatchMakingProfileStepOne() {
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeMatchMakingNavigationBar()
        }
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        KAPPDELEGATE.updateRootController(MatchMakingBasicInfoController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func checkCompleteProfileStatus() {
        let registrationStep = Int(KAPPSTORAGE.registrationStep) ?? -1
        let userType = Int(KAPPSTORAGE.userType) ?? 1
        let isDeactivate = Int(KAPPSTORAGE.isDeactivate) ?? 0
        
        if KUSERMODEL.isLoggedIn() {
            if registrationStep == 1 {
                if userType == 1 {
                    //proceedToStepOneViewController()
                    proceedToBasicInfoScreen()
                } else if userType == 2 {
                    proceedForListingMatchMaking()
                } else {
                   // proceedToStepOneViewController()
                    proceedToBasicInfoScreen()
                }
            } else if registrationStep == 2 {
                if userType == 1 {
                    if isDeactivate == 1 {
                        proceedForListingMatchMaking()
                    } else {
                        proceedForHome()
                    }
                } else if userType == 2 {
                    proceedForListingMatchMaking()
                } else {
                   // proceedToStepOneViewController()
                    proceedToBasicInfoScreen()
                }
            } else {
                proceedToBasicInfoScreen()
            }
        } else {
            if registrationStep == -1 {
                proceedToNextScreen()
            } else if registrationStep >= 1 {
               // proceedToStepOneViewController()
                proceedToBasicInfoScreen()
            } else {
                proceedToBasicInfoScreen()
            }
        }
    }
}
