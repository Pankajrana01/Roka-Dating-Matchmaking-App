//
//  OnboardingViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 19/07/23.
//

import Foundation
import UIKit

class OnboardingViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?

    func proceedToRegisterScreen(registerFor:String) {
        SignupViewController.show(from: self.hostViewController, forcePresent: false , isComeFor: registerFor) { success in
        }
    }
    
}
