//
//  LandingWalkThroughConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var landingWalkThrough: UIStoryboard {
        return UIStoryboard(name: "LandingWalkThrough", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let landingWalkThrough        = "LandingWalkThroughViewController"
    static let onboarding                = "OnboardingViewController"
    static let homeWalkThrough           = "HomeWalkThroughViewController"
}
