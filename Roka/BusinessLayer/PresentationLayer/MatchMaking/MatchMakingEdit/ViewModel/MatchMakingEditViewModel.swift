//
//  MatchMakingEditViewModel.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import Foundation

class MatchMakingEditViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var selectedProfile : ProfilesModel?
    
    
    func proceedToMatchMakingBasicInfo() {
        MatchMakingBasicInfoController.show(from: self.hostViewController, forcePresent: false, isComeFor: "EditBasicInfoMatchMaking", receivedProfile: selectedProfile) { success in }
    }
    
    func proceedForEditPlaceholderImageScreen() {
        MatchMakingPlaceholderController.show(from: self.hostViewController, forcePresent: false, isComeFor: "EditMatchingProfile", selectedProfile: selectedProfile, profileResponseData: [:], basicDetailsDictionary: [:]) { success in
        }
    }
    
    func proceedForEditAddMoreDetails() {
        DetailPagerController.show(from: self.hostViewController, forcePresent: false, isCome: "EditMatchingProfile")
    }
    
    func proceedForEditProfilePreferenceScreen() {
        MoreDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Friend My Preferences") { success in
        }
    }
    
    
    func proceedForDeleteProfile(id: String) {
        let controller = DeleteAccountViewController.getController() as! DeleteAccountViewController
        controller.dismissCompletion = { value in
            if value == "yes" {
                self.hostViewController.navigationController?.popViewController(animated: true)
            }
        }
        controller.show(over: self.hostViewController, isComeFrom: "EditFriendProfile", friendId: id) { value  in
            
        }
    }
    
}
