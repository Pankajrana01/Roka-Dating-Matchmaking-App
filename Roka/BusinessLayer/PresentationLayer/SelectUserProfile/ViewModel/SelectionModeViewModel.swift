//
//  SelectionModeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 19/07/23.
//

import Foundation
import UIKit
import CoreLocation

class SelectionModeViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    
    func proceedForOnBoardingScreen(isComeFor:String) {
        OnboardingViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: isComeFor) { success in
        }
    }
}
